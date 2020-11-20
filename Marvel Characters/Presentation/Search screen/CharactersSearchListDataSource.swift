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
	
	var searchTextStream = PassthroughSubject<String, Never>()
	
	init(charactersRepository: MarvelCharactersRepository) {
		self.charactersRepository = charactersRepository
		
		searchTextStream.debounce(for: .milliseconds(Constants.searchDebounceDelay), scheduler: RunLoop.main).sink { (newSearchText) in
			if newSearchText.count > 1 {
				self.updateCharacters(searchText: newSearchText)
			} else {
				self.characters = []
				self.delegate?.reloadSearchListResults()
			}
		}
		.store(in: &cancellables)
	}
	
	private func updateCharacters(searchText: String) {
		
		if searchText.isEmpty {
			self.characters = []
			self.delegate?.reloadSearchListResults()
			return
		}
		
		charactersRepository.searchCharacters(startingWith: searchText).receive(on: RunLoop.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				DispatchQueue.main.async {
					self.delegate?.errorWithSearchResults(error)
				}
			case .finished:
				break
			}
		}, receiveValue: { (characters) in
			self.characters = characters
			self.delegate?.reloadSearchListResults()
		})
		.store(in: &cancellables)
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
