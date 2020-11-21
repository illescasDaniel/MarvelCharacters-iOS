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

	private var images: [Int: UIImage] = [:]
	private var cachedImageForThumbnailURL: [String: UIImage] = [:]
	private static var commonImagesPool: [String: [UIImage]] = [:]
	private let charactersRepository: MarvelCharactersRepository = MarvelCharactersRepositoryImplementation()
	private var cancellables: [Int: AnyCancellable] = [:]
	
	private var downloadedImagesIndexStream = PassthroughSubject<Int, Never>()
	
	let imagesSize: CoreGraphics.CGFloat
	
	init(imagesSize: CoreGraphics.CGFloat) {
		self.imagesSize = imagesSize
	}
	
	func downloadImage(_ thumbnailURL: String, forIndex index: Int) {
		
		if cancellables.keys.contains(index) {
			return
		}
		
		if let cachedImage = self.imageFor(thumbnailURL: thumbnailURL) {
			self.images[index] = cachedImage
			self.cachedImageForThumbnailURL[thumbnailURL] = cachedImage
			self.downloadedImagesIndexStream.send(index)
			return
		}
		
		let url = URL(string: thumbnailURL)!
		cancellables[index] = charactersRepository.downloadCharacterThumbnail(url).sink(receiveCompletion: { (completion) in
			if case .failure = completion {
				self.images[index] = Asset.placeholderImage
			}
		}, receiveValue: { (data) in
			guard let image = UIImage(data: data)?.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill) else { return }
			self.images[index] = image
			self.cachedImageForThumbnailURL[thumbnailURL] = image
			
			if Constants.useAgressiveCaching {
				let commonThumbnailURLPath = (thumbnailURL as NSString).deletingLastPathComponent
				if let cachedImagesForURL = Self.commonImagesPool[thumbnailURL] {
					if !cachedImagesForURL.contains(where: { $0.size.width == self.imagesSize }) {
						Self.commonImagesPool[commonThumbnailURLPath] = cachedImagesForURL + [image]
					}
				} else {
					Self.commonImagesPool[commonThumbnailURLPath] = [image]
				}
			}
			self.downloadedImagesIndexStream.send(index)
		})
	}
	
	func imageFor(index: Int) -> UIImage? {
		return images[index]
	}
	
	private let locker = NSLock()
	
	func imageFor(thumbnailURL: String) -> UIImage? {
		locker.lock()
		defer { locker.unlock() }
		if let cachedImage = cachedImageForThumbnailURL[thumbnailURL] {
			return cachedImage
		}
		if Constants.useAgressiveCaching {
			let commonThumbnailURLPath = (thumbnailURL as NSString).deletingLastPathComponent
			if let cachedImagesForURL = Self.commonImagesPool[commonThumbnailURLPath], !cachedImagesForURL.isEmpty {
				if let cachedImageForSize = cachedImagesForURL.first(where: { $0.size.width == self.imagesSize }) {
					print("used exact size image from common images pool")
					return cachedImageForSize
				}
				if let alternativeBiggerImage = cachedImagesForURL.first(where: { $0.size.width > self.imagesSize }) {
					print("found bigger image in common images pool")
					let image = alternativeBiggerImage.resizeImage(self.imagesSize, opaque: true, contentMode: .scaleAspectFill)
					Self.commonImagesPool[commonThumbnailURLPath] = cachedImagesForURL + [image]
					return image
				}
			}
		}
		return nil
	}
	
	var publisher: AnyPublisher<Int, Never> {
		downloadedImagesIndexStream.eraseToAnyPublisher()
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
