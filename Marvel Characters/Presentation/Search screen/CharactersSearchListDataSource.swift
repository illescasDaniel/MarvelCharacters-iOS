//
//  CharactersSearchListDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation
import Combine
import class UIKit.UIImage
import class UIKit.UIScreen

protocol CharactersSearchListDataSourceDelegate: class {
	func reloadSearchListResults()
	func reloadRows(indices: [Int])
	func errorWithSearchResults(_ error: Error)
}

class CharactersSearchListDataSource {
	
	weak var delegate: CharactersSearchListDataSourceDelegate?
	
	private(set) var characters: [MarvelCharacter] = []
	
	private let characterImagesController = CharacterImagesController(imagesSize: Constants.searchCharactersRowImageSize)
	private let charactersRepository: MarvelCharactersRepository
	private var cancellables: [AnyCancellable] = []
	
	var searchTextStream = PassthroughSubject<String, Never>()
	
	private let marvelImageThumbnailQuality: MarvelImage.ThumbnailQuality = .standardMedium_100px
	
	init(charactersRepository: MarvelCharactersRepository) {
		self.charactersRepository = charactersRepository
		setupSearchTextStream()
		setupImageLoading()
	}
	
	func downloadThumbnail(_ thumbnail: MarvelImage, forIndex: Int) {
		characterImagesController.downloadImage(thumbnail.imageURL(withQuality: marvelImageThumbnailQuality), forIndex: forIndex)
	}
	
	func thumbnail(forIndex index: Int) -> UIImage? {
		return characterImagesController.imageFor(thumbnailURL: characters[index].thumbnail.imageURL(withQuality: marvelImageThumbnailQuality))
	}
	
	func cancelRequests() {
		cancellables.forEach {
			$0.cancel()
		}
		cancellables.removeAll()
	}
	
	// MARK: Convenience
	
	private func setupSearchTextStream() {
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
	
	private func setupImageLoading() {
		let imagesControllerPublisher = self.characterImagesController.publisher.collect(.byTime(DispatchQueue.main, .milliseconds(300)))
		cancellables.append(imagesControllerPublisher.receive(on: DispatchQueue.main).sink { (rowIndicesToReload) in
			self.delegate?.reloadRows(indices: rowIndicesToReload)
		})
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
			self.characterImagesController.cancelRequests()
			for (characterToAddThumbnail, index) in zip(characters, 0..<characters.count) {
				self.downloadThumbnail(characterToAddThumbnail.thumbnail, forIndex: index)
			}
			self.characters = characters
			self.delegate?.reloadSearchListResults()
		})
		.store(in: &cancellables)
	}
	
	deinit {
		cancelRequests()
	}
}
