//
//  CharacterImageController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation
import UIKit
import Combine

class CharacterImagesController {

	private var imagesIndexPath: [IndexPath: UIImage] = [:]
	private var imagesByMarvelCharacterHash: [Int: UIImage] = [:]
	private var cachedImageForThumbnailURL: [String: UIImage] = [:]
	private let charactersRepository: MarvelCharactersRepository = MarvelCharactersRepositoryImplementation()
	private var cancellables: [IndexPath: AnyCancellable] = [:]
	private var cancellablesByMarvelCharacterHash: [Int: AnyCancellable] = [:]
	private var otherCancellables: [AnyCancellable] = []
	
	private var downloadedImagesCharacterStream = PassthroughSubject<MarvelCharacter, Never>()
	private var downloadedImagesIndexPathStream = PassthroughSubject<IndexPath, Never>()
	
	private let queue = DispatchQueue(label: "Images controller")
	
	private let locker = NSLock()
	
	let imagesSize: CoreGraphics.CGFloat
	
	init(imagesSize: CoreGraphics.CGFloat) {
		self.imagesSize = imagesSize
	}
	
	func downloadImage(for character: MarvelCharacter, thumbnailURL: String) {
		queue.async {
			
			let characterHashValue = character.hashValue
			
			if self.cancellablesByMarvelCharacterHash.keys.contains(characterHashValue) {
				return
			}
			
			if let cachedImage = self.imageCachingDiskFor(thumbnailURL: thumbnailURL, character: character) { //self.imageFor(thumbnailURL: thumbnailURL, path: character.thumbnail.path) {
				self.imagesByMarvelCharacterHash[characterHashValue] = cachedImage
				if cachedImage != self.defaultAssetImage {
					self.cachedImageForThumbnailURL[thumbnailURL] = cachedImage
					self.downloadedImagesCharacterStream.send(character)
				}
				return
			}
			
			let url = URL(string: thumbnailURL)!
			self.cancellablesByMarvelCharacterHash[characterHashValue] = self.charactersRepository.downloadCharacterThumbnail(url).sink(receiveCompletion: { (completion) in
				if case .failure = completion {
					self.imagesByMarvelCharacterHash[characterHashValue] = self.defaultAssetImage
					self.downloadedImagesCharacterStream.send(character)
				}
			}, receiveValue: { (data) in
				guard let image = UIImage(data: data)?.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill) else { return }
				self.imagesByMarvelCharacterHash[characterHashValue] = image
				self.cachedImageForThumbnailURL[thumbnailURL] = image
				
				if Constants.useAgressiveCaching {
					CommonImagesPoolController.shared.save(image: image, forURLPath: character.thumbnail.path, withImageSize: self.imagesSize)
					DiskImagesPoolController.shared.saveImageDataOnDisk(imageData: data, forURLPath: character.thumbnail.path, withImageSize: self.imagesSize)
				}
				self.downloadedImagesCharacterStream.send(character)
			})
		}
	}
	
	func imageFor(character: MarvelCharacter) -> UIImage? {
		return self.imagesByMarvelCharacterHash[character.hashValue]
	}
	
	func downloadImage(_ thumbnailURL: String, withCommonPath path: String, forIndexPath indexPath: IndexPath) {
		queue.async {
			if self.imagesIndexPath[indexPath] == self.defaultAssetImage {
				self.cancellables.removeValue(forKey: indexPath)
			}
			
			if self.cancellables.keys.contains(indexPath) {
				return
			}
			
			if let cachedImage = self.imageFor(thumbnailURL: thumbnailURL, path: path, indexPath: indexPath) {
				self.imagesIndexPath[indexPath] = cachedImage
				if cachedImage != self.defaultAssetImage {
					self.cachedImageForThumbnailURL[thumbnailURL] = cachedImage
					self.downloadedImagesIndexPathStream.send(indexPath)
				}
				return
			}
			
			let url = URL(string: thumbnailURL)!
			self.cancellables[indexPath] = self.charactersRepository.downloadCharacterThumbnail(url).sink(receiveCompletion: { (completion) in
				if case .failure = completion {
					self.imagesIndexPath[indexPath] = self.defaultAssetImage
					self.downloadedImagesIndexPathStream.send(indexPath)
				}
			}, receiveValue: { (data) in
				guard let image = UIImage(data: data)?.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill) else { return }
				self.imagesIndexPath[indexPath] = image
				self.cachedImageForThumbnailURL[thumbnailURL] = image
				
				if Constants.useAgressiveCaching {
					CommonImagesPoolController.shared.save(image: image, forURLPath: path, withImageSize: self.imagesSize)
					DiskImagesPoolController.shared.saveImageDataOnDisk(imageData: data, forURLPath: path, withImageSize: self.imagesSize)
				}
				self.downloadedImagesIndexPathStream.send(indexPath)
			})
		}
	}
	
	func downloadImage(_ thumbnailURL: String, withCommonPath path: String) -> AnyPublisher<UIImage, URLError> {
		
		if let cachedImage = self.retrieveImageFor(thumbnailURL: thumbnailURL, path: path) {
			self.cachedImageForThumbnailURL[thumbnailURL] = cachedImage
			return Just(cachedImage).setFailureType(to: URLError.self).eraseToAnyPublisher()
		}
		
		let url = URL(string: thumbnailURL)!
		return self.charactersRepository.downloadCharacterThumbnail(url).flatMap { (data) -> AnyPublisher<UIImage, URLError> in
			guard let image = UIImage(data: data)?.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill) else {
				return Fail(error: URLError(.cannotDecodeContentData)).eraseToAnyPublisher()
			}
			self.cachedImageForThumbnailURL[thumbnailURL] = image
			
			if Constants.useAgressiveCaching {
				CommonImagesPoolController.shared.save(image: image, forURLPath: path, withImageSize: self.imagesSize)
				DiskImagesPoolController.shared.saveImageDataOnDisk(imageData: data, forURLPath: path, withImageSize: self.imagesSize)
			}
			return Just(image).setFailureType(to: URLError.self).eraseToAnyPublisher()
		}.eraseToAnyPublisher()
	}
	
	func imageFor(indexPath: IndexPath) -> UIImage? {
		return self.imagesIndexPath[indexPath]
	}
	
	func imageFor(thumbnailURL: String, path: String) -> UIImage? {
		locker.lock()
		defer { locker.unlock() }
		if let cachedImage = self.cachedImageForThumbnailURL[thumbnailURL] {
			return cachedImage
		}
		if Constants.useAgressiveCaching {
			if let commonCachedImage = CommonImagesPoolController.shared.retrieveImage(forURLPath: path, forImageSize: self.imagesSize) {
				return commonCachedImage
			}
		}
		return nil
	}
	
	private func imageCachingDiskFor(thumbnailURL: String, character: MarvelCharacter) -> UIImage? {
//		locker.lock()
//		defer { locker.unlock() }
		let path = character.thumbnail.path
		if let cachedImage = self.cachedImageForThumbnailURL[thumbnailURL] {
			return cachedImage
		}
		if Constants.useAgressiveCaching {
			if let commonCachedImage = CommonImagesPoolController.shared.retrieveImage(forURLPath: path, forImageSize: self.imagesSize) {
				return commonCachedImage
			}
			
//			let diskImageExists = DiskImagesPoolController.shared.retrieveSavedImageDataOnDiskAsync(forURLPath: path, withImageSize: self.imagesSize, completionHandler: { imageData in
//				if let recoveredImage = imageData.flatMap({ UIImage(data: $0) }) {
//					self.locker.lock()
//					defer { self.locker.unlock() }
//					print("Using image data from disk (async)")
//					let resizedImage = recoveredImage.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill)
//					self.cachedImageForThumbnailURL[thumbnailURL] = resizedImage
//					CommonImagesPoolController.shared.save(image: resizedImage, forURLPath: path, withImageSize: self.imagesSize)
//					self.downloadedImagesCharacterStream.send(character)
//				}
//			})
//
//			if diskImageExists {
//				return self.defaultAssetImage
//			}
		}
		return nil
	}
	
	private func retrieveImageFor(thumbnailURL: String, path: String) -> UIImage? {
		locker.lock()
		defer { locker.unlock() }
		if let cachedImage = self.cachedImageForThumbnailURL[thumbnailURL] {
			return cachedImage
		}
		if Constants.useAgressiveCaching {
			if let commonCachedImage = CommonImagesPoolController.shared.retrieveImage(forURLPath: path, forImageSize: self.imagesSize) {
				return commonCachedImage
			}
//			if let imageDataFromDisk = DiskImagesPoolController.shared.retrieveSavedImageDataOnDisk(forURLPath: path, withImageSize: self.imagesSize),
//			   let image = UIImage(data: imageDataFromDisk)?.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill) {
//				
//				self.locker.lock()
//				defer { self.locker.unlock() }
//				print("Using image data from disk (sync)")
//				self.cachedImageForThumbnailURL[thumbnailURL] = image
//				CommonImagesPoolController.shared.save(image: image, forURLPath: path, withImageSize: self.imagesSize)
//				return image
//			}
		}
		return nil
	}
	
	private func imageFor(thumbnailURL: String, path: String, indexPath: IndexPath) -> UIImage? {
		locker.lock()
		defer { locker.unlock() }
		if let cachedImage = self.cachedImageForThumbnailURL[thumbnailURL] {
			return cachedImage
		}
		if Constants.useAgressiveCaching {
			if let commonCachedImage = CommonImagesPoolController.shared.retrieveImage(forURLPath: path, forImageSize: self.imagesSize) {
				return commonCachedImage
			}
			
			let diskImageExists = DiskImagesPoolController.shared.retrieveSavedImageDataOnDiskAsync(forURLPath: path, withImageSize: self.imagesSize, completionHandler: { imageData in
				if let recoveredImage = imageData.flatMap({ UIImage(data: $0) }) {
					self.locker.lock()
					defer { self.locker.unlock() }
					print("Using image data from disk (async)")
					let resizedImage = recoveredImage.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill)
					self.cachedImageForThumbnailURL[thumbnailURL] = resizedImage
					CommonImagesPoolController.shared.save(image: resizedImage, forURLPath: path, withImageSize: self.imagesSize)
					self.downloadedImagesIndexPathStream.send(indexPath)
				}
			})

			if diskImageExists {
				return self.defaultAssetImage
			}
		}
		return nil
	}
	
	var publisher: AnyPublisher<IndexPath, Never> {
		self.downloadedImagesIndexPathStream.eraseToAnyPublisher()
	}
	
	var charactersPublisher: AnyPublisher<MarvelCharacter, Never> {
		self.downloadedImagesCharacterStream.eraseToAnyPublisher()
	}
	
	lazy var defaultAssetImage: UIImage = {
		self.imagesSize == Constants.characterInSearchResultRowImageSize ? Asset.smallPlaceholderImage : Asset.placeholderImage
	}()
	
	func cancelRequests() {
		self.cancellables.values.forEach {
			$0.cancel()
		}
		self.cancellables.removeAll(keepingCapacity: true)
		self.otherCancellables.forEach {
			$0.cancel()
		}
		self.otherCancellables.removeAll(keepingCapacity: true)
		
		self.cancellablesByMarvelCharacterHash.forEach {
			$0.value.cancel()
		}
		self.cancellablesByMarvelCharacterHash.removeAll(keepingCapacity: true)
	}
	
	func cleanImagesByIndexPath() {
		self.imagesIndexPath.removeAll(keepingCapacity: true)
	}
	
	deinit {
		cancelRequests()
	}
}
