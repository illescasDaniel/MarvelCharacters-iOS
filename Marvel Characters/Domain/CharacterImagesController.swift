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
	private var cachedImageForThumbnailURL: [String: UIImage] = [:]
	private let charactersRepository: MarvelCharactersRepository = MarvelCharactersRepositoryImplementation()
	private var cancellables: [IndexPath: AnyCancellable] = [:]
	
	private var downloadedImagesIndexStream = PassthroughSubject<Int, Never>()
	private var downloadedImagesIndexPathStream = PassthroughSubject<IndexPath, Never>()
	
	private let locker = NSLock()
	
	let imagesSize: CoreGraphics.CGFloat
	
	init(imagesSize: CoreGraphics.CGFloat) {
		self.imagesSize = imagesSize
	}
	
	func downloadImage(_ thumbnailURL: String, withCommonPath path: String, forIndexPath indexPath: IndexPath) {
		
		if cancellables.keys.contains(indexPath) {
			return
		}
		
		if let cachedImage = self.imageFor(thumbnailURL: thumbnailURL, path: path) {
			self.imagesIndexPath[indexPath] = cachedImage
			self.cachedImageForThumbnailURL[thumbnailURL] = cachedImage
			self.downloadedImagesIndexPathStream.send(indexPath)
			return
		}
		
		let url = URL(string: thumbnailURL)!
		cancellables[indexPath] = charactersRepository.downloadCharacterThumbnail(url).sink(receiveCompletion: { (completion) in
			if case .failure = completion {
				self.imagesIndexPath[indexPath] = Asset.placeholderImage
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
	
	func imageFor(indexPath: IndexPath) -> UIImage? {
		return imagesIndexPath[indexPath]
	}
	
	func imageFor(thumbnailURL: String, path: String) -> UIImage? {
		locker.lock()
		defer { locker.unlock() }
		if let cachedImage = cachedImageForThumbnailURL[thumbnailURL] {
			return cachedImage
		}
		if Constants.useAgressiveCaching {
			if let commonCachedImage = CommonImagesPoolController.shared.retrieveImage(forURLPath: path, forImageSize: self.imagesSize) {
				return commonCachedImage
			}
			if let diskImageData = DiskImagesPoolController.shared.retrieveSavedImageDataOnDisk(forURLPath: path, withImageSize: self.imagesSize), let recoveredImage = UIImage(data: diskImageData) {
				print("Using image data from disk")
				let resizedImage = recoveredImage.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill)
				CommonImagesPoolController.shared.save(image: resizedImage, forURLPath: path, withImageSize: self.imagesSize)
				return resizedImage
			}
		}
		return nil
	}
	
	var publisher: AnyPublisher<IndexPath, Never> {
		downloadedImagesIndexPathStream.eraseToAnyPublisher()
	}
	
	func cancelRequests() {
		cancellables.values.forEach {
			$0.cancel()
		}
		cancellables.removeAll(keepingCapacity: true)
	}
	
	deinit {
		cancelRequests()
	}
}
