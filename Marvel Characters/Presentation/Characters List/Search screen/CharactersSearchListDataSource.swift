//
//  CharactersSearchListDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation
import Combine

protocol CharactersSearchListDataSourceDelegate: class {
	func reloadSearchListResults()
	func errorWithSearchResults(_ error: Error)
}

class CharactersSearchListDataSource {
	
	weak var delegate: CharactersSearchListDataSourceDelegate?
	
	private(set) var characters: [MarvelCharacter] = []
	
	private let charactersRepository: MarvelCharactersRepository
	private var cancellables: [AnyCancellable] = []
	
	init(charactersRepository: MarvelCharactersRepository) {
		self.charactersRepository = charactersRepository
	}
	
	func updateCharacters(searchText: String) {
		
		if searchText.isEmpty {
			self.characters = []
			self.delegate?.reloadSearchListResults()
			return
		}
		
		cancellables.append(charactersRepository.searchCharacters(startingWith: searchText).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				self.delegate?.errorWithSearchResults(error)
			case .finished:
				break
			}
		}, receiveValue: { (characters) in
			self.characters = characters
			self.delegate?.reloadSearchListResults()
		}))
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
