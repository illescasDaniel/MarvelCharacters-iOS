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
	func reloadRows(at indexPaths: [IndexPath])
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
	
	func downloadThumbnail(_ thumbnail: MarvelImage, forIndexPath indexPath: IndexPath) {
		self.characterImagesController.downloadImage(thumbnail.imageURL(withQuality: self.marvelImageThumbnailQuality), withCommonPath: thumbnail.path, forIndexPath: indexPath)
	}
	
	func thumbnail(forImagePath imagePath: MarvelImage) -> UIImage? {
		return self.characterImagesController.imageFor(thumbnailURL: imagePath.imageURL(withQuality: self.marvelImageThumbnailQuality), path: imagePath.path)
	}
	
	func cancelRequests() {
		self.cancellables.forEach {
			$0.cancel()
		}
		self.cancellables.removeAll(keepingCapacity: true)
	}
	
	// MARK: Convenience
	
	private func setupSearchTextStream() {
		self.searchTextStream.debounce(for: .milliseconds(Constants.searchDebounceDelay), scheduler: RunLoop.main).sink { (newSearchText) in
			if newSearchText.count > 1 {
				self.updateCharacters(searchText: newSearchText)
			} else {
				self.characters = []
				self.delegate?.reloadSearchListResults()
			}
		}
		.store(in: &self.cancellables)
	}
	
	private func setupImageLoading() {
		let imagesControllerPublisher = self.characterImagesController.publisher.collect(.byTime(DispatchQueue.main, .milliseconds(300)))
		self.cancellables.append(imagesControllerPublisher.receive(on: DispatchQueue.main).sink { (indexPathsToDelete) in
			self.delegate?.reloadRows(at: indexPathsToDelete)
		})
	}
	
	private func updateCharacters(searchText: String) {
		
		if searchText.isEmpty {
			self.characters = []
			self.delegate?.reloadSearchListResults()
			return
		}
		
		self.charactersRepository.searchCharacters(startingWith: searchText).receive(on: RunLoop.main).sink(receiveCompletion: { (completion) in
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
			self.characterImagesController.cleanImagesByIndexPath()
			for (characterToAddThumbnail, index) in zip(characters, 0..<characters.count) {
				self.downloadThumbnail(characterToAddThumbnail.thumbnail, forIndexPath: IndexPath(row: index, section: 0))
			}
			self.characters = characters
			self.delegate?.reloadSearchListResults()
		})
		.store(in: &self.cancellables)
	}
	
	deinit {
		cancelRequests()
	}
}
