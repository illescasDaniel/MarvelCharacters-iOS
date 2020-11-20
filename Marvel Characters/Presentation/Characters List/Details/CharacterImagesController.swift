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
	private let charactersRepository: MarvelCharactersRepository = MarvelCharactersRepositoryImplementation()
	private var cancellables: [Int: AnyCancellable] = [:]
	
	private var downloadedImagesIndexStream = PassthroughSubject<Int, Never>()
	
	func downloadImage(_ thumbnailURL: String, forIndex index: Int) {
		
		if cancellables.keys.contains(index) || images.keys.contains(index) {
			return
		}
		
		if let cachedImage = self.cachedImageForThumbnailURL[thumbnailURL] {
			self.images[index] = cachedImage
			self.downloadedImagesIndexStream.send(index)
			return
		}
		
		cancellables[index] = charactersRepository.downloadCharacterThumbnail(thumbnailURL).sink(receiveCompletion: { (completion) in
			if case .failure = completion {
				self.images[index] = Asset.placeholderImage
			}
		}, receiveValue: { (data) in
			guard let image = UIImage(data: data)?.resizeImage(Constants.charactersRowImageSize, opaque: true, contentMode: .scaleAspectFill) else { return }
			self.images[index] = image
			self.cachedImageForThumbnailURL[thumbnailURL] = image
			self.downloadedImagesIndexStream.send(index)
		})
	}
	
	func imageFor(index: Int) -> UIImage? {
		return images[index]
	}
	
	var publisher: AnyPublisher<Int, Never> {
		downloadedImagesIndexStream.eraseToAnyPublisher()
	}
}
