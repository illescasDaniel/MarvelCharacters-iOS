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
	//private var imageForThumbnailURL: [String: UIImage]
	private let charactersRepository: MarvelCharactersRepository = MarvelCharactersRepositoryImplementation()
	private var cancellables: [Int: AnyCancellable] = [:]
	
	private var downloadedImagesIndexStream = PassthroughSubject<Int, Never>()
	
	func downloadImage(_ thumbnailURL: String, forIndex index: Int) {
		
		if cancellables.keys.contains(index) || images.keys.contains(index) {
			return
		}
		
		cancellables[index] = charactersRepository.downloadCharacterThumbnail(thumbnailURL).sink(receiveCompletion: { (completion) in
			if case .failure = completion {
				self.images[index] = UIImage(named: "Placeholder")?.resizeImage(66, opaque: true, contentMode: .scaleAspectFill)
			}
		}, receiveValue: { (data) in
			self.images[index] = UIImage(data: data)?.resizeImage(66, opaque: true, contentMode: .scaleAspectFill)
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
