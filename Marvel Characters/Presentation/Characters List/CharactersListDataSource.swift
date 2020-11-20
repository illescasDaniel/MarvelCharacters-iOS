//
//  CharactersListDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation
import Combine
import class UIKit.UIImage

protocol CharactersListDataSourceDelegate: class {
	func reloadList()
	func reloadRow(index: Int)
	func reloadRows(indices: [Int])
	func errorLoading(_ error: Error)
}

class CharactersListDataSource {
	
	weak var delegate: CharactersListDataSourceDelegate?
	
	private(set) var characters: [MarvelCharacter] = []
	private var page: Int = 0
	
	private let characterImagesController = CharacterImagesController()
	private let charactersRepository: MarvelCharactersRepository
	private var cancellables: [AnyCancellable] = []
	
	init(charactersRepository: MarvelCharactersRepository) {
		self.charactersRepository = charactersRepository
		
		let imagesControllerPublisher = self.characterImagesController.publisher.collect(.byTimeOrCount( DispatchQueue.main, .milliseconds(500), 10))
		cancellables.append(imagesControllerPublisher.receive(on: DispatchQueue.main).sink { (rowIndicesToReload) in
			self.delegate?.reloadRows(indices: rowIndicesToReload)
		})
	}
	
	func loadData() {
		let request = charactersRepository.charactersSortedByNamePaginated(limit: 20, page: page)
		cancellables.append(request.receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				DispatchQueue.main.async {
					self.delegate?.errorLoading(error)
				}
			case .finished:
				break
			}
		}, receiveValue: { (characters) in
			self.characters = characters
			self.delegate?.reloadList()
		}))
	}
	
	func downloadThumbnail(_ thumbnailURL: String, forIndex: Int) {
		characterImagesController.downloadImage(thumbnailURL, forIndex: forIndex)
	}
	
	func thumbnail(forIndex index: Int) -> UIImage? {
		return characterImagesController.imageFor(index: index)
	}
	
	func cancelRequests() {
		cancellables.forEach {
			$0.cancel()
		}
	}
	
	deinit {
		cancelRequests()
	}
}
