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

protocol CharactersSearchListDataSourceDelegate: AnyObject {
	func reloadSearchListResults()
	func reloadRows(at indexPaths: [IndexPath])
	func errorWithSearchResults(_ error: Error)
}

class CharactersSearchListDataSource {
	
	// MARK: Properties
	
	weak var delegate: CharactersSearchListDataSourceDelegate?
	
	let searchTextStream = PassthroughSubject<String, Never>()
	private(set) var characters: [MarvelCharacter] = []
	
	private let characterImagesController = CharacterImagesController(imagesSize: Constants.characterInSearchResultRowImageSize)
	private let charactersRepository: MarvelCharactersRepository
	private var cancellables: [AnyCancellable] = []
	private var paginatedCancellables: [Int: AnyCancellable] = [:]
	private var page: Int = 0
	private var currentSearchText: String = ""
	private let marvelImageThumbnailQuality: MarvelImage.ThumbnailQuality = .standardMedium_100px
	
	// MARK: Initializers
	
	init(charactersRepository: MarvelCharactersRepository) {
		self.charactersRepository = charactersRepository
		setupSearchTextStream()
		setupImageLoading()
	}
	
	// MARK: Public methods
	
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
		cancelPaginatedRequests()
	}
	
	func loadMoreData() {
		guard self.currentSearchText.count > 1 else { return }
		guard self.paginatedCancellables[self.page] == nil else { return }
		
		let request = self.charactersRepository.searchCharactersPaginated(startingWith: self.currentSearchText, limit: Constants.charactersSearchPageSize, page: self.page)
		self.paginatedCancellables[self.page] = request.sink(receiveCompletion: { (completion) in
			if case .failure(let error) = completion {
				DispatchQueue.main.async {
					self.delegate?.errorWithSearchResults(error)
				}
			}
		}, receiveValue: { (moreCharacters) in
			let currentNumberOfCharacters = self.characters.count
			self.characters += moreCharacters
			var indexPathsAndImageToLoad: [(MarvelImage, IndexPath)] = []
			for (characterToAddThumbnail, index) in zip(moreCharacters, currentNumberOfCharacters..<self.characters.count) {
				let indexPath = IndexPath(row: index, section: 0)
				indexPathsAndImageToLoad.append((characterToAddThumbnail.thumbnail, indexPath))
			}
			
			if moreCharacters.count == Constants.charactersSearchPageSize /* limit */ {
				self.page += 1
			}
			
			DispatchQueue.main.async {
				self.delegate?.reloadSearchListResults()
				
				indexPathsAndImageToLoad.forEach {
					self.downloadThumbnail($0, forIndexPath: $1)
				}
			}
		})
	}
	
	// MARK: Convenience
	
	private func cancelPaginatedRequests() {
		self.paginatedCancellables.forEach {
			$0.value.cancel()
		}
		self.paginatedCancellables.removeAll(keepingCapacity: true)
	}
	
	private func setupSearchTextStream() {
		self.searchTextStream.debounce(for: .milliseconds(Constants.searchDebounceDelay), scheduler: DispatchQueue.main).sink { (newSearchText) in
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
		
		if searchText == self.currentSearchText, !self.characters.isEmpty {
			return
		}
		
		cancelPaginatedRequests()
		
		self.currentSearchText = searchText
		self.page = 0
		
		if searchText.isEmpty {
			self.characters = []
			DispatchQueue.main.async {
				self.delegate?.reloadSearchListResults()
			}
			return
		}
		
		let request = self.charactersRepository.searchCharactersPaginated(startingWith: self.currentSearchText, limit: Constants.charactersSearchPageSize, page: self.page)
		self.paginatedCancellables[self.page] = request.sink(receiveCompletion: { (completion) in
			if case .failure(let error) = completion {
				DispatchQueue.main.async {
					self.delegate?.errorWithSearchResults(error)
				}
			}
		}, receiveValue: { (characters) in
			self.characterImagesController.cancelRequests()
			self.characterImagesController.cleanImagesByIndexPath()
			for (characterToAddThumbnail, index) in zip(characters, 0..<characters.count) {
				self.downloadThumbnail(characterToAddThumbnail.thumbnail, forIndexPath: IndexPath(row: index, section: 0))
			}
			self.characters = characters
			if characters.count == Constants.charactersSearchPageSize /* limit */ {
				self.page += 1
			}
			DispatchQueue.main.async {
				self.delegate?.reloadSearchListResults()
			}
		})
	}
	
	deinit {
		cancelRequests()
	}
}
