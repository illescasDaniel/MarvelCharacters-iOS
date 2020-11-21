//
//  CharacterDetailDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import Foundation
import Combine
import class UIKit.UIImage

protocol CharactersDetailDataSourceDelegate: class {
	func didLoadCharacterImage(_ image: UIImage)
	func errorLoadingImage(_ error: Error)
}

class CharacterDetailDataSource {
	
	weak var delegate: CharactersDetailDataSourceDelegate?
	
	private let imagesController = CharacterImagesController(imagesSize: Constants.characterDetailImageSize)
	private var cancellables: [AnyCancellable] = []
	
	init() {}
	
	func downloadCharacterImage(fromPath imagePath: MarvelImage) {
		//DispatchQueue.global(qos: .background).async {
			self.imagesController.downloadImage(imagePath.imageURL(withQuality: .standardLarge_200px), withCommonPath: imagePath.path)
				.receive(on: DispatchQueue.main)
				.sink { (completion) in
					if case .failure(let error) = completion {
						dump(error)
						DispatchQueue.main.async {
							self.delegate?.errorLoadingImage(error)
						}
					}
				} receiveValue: { (image) in
					self.delegate?.didLoadCharacterImage(image)
				}
				.store(in: &self.cancellables)
		//}
	}
	
}
