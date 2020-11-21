//
//  CharactersListDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation
import Combine
import class UIKit.UIImage
import class UIKit.UIScreen

protocol CharactersListDataSourceDelegate: class {
	func reloadList()
	func reloadRow(index: Int)
	func reloadRows(at indexPaths: [IndexPath])
	func didStartLoading()
	func didFinishLoading()
	func errorLoading(_ error: Error)
}

class CharactersListDataSource {
	
	weak var delegate: CharactersListDataSourceDelegate?
	
	private(set) var characterSections: [CharacterSection] = []
	private(set) var charactersCount: Int = 0
	
	enum CharactersOrder {
		case ascending, descending
		func opposite() -> CharactersOrder {
			self == .ascending ? .descending : .ascending
		}
		mutating func toggle() {
			self = opposite()
		}
	}
	private var charactersOrder: CharactersOrder = .ascending
	
	private var page: Int = 0
	
	private let characterImagesController = CharacterImagesController(imagesSize: Constants.characterRowImageSize)
	private let charactersRepository: MarvelCharactersRepository
	private var paginatedCancellables: [Int: AnyCancellable] = [:]
	private var cancellables: [AnyCancellable] = []
	
	private let marvelImageThumbnailQuality: MarvelImage.ThumbnailQuality = {
		switch UIScreen.main.scale {
		case 1:
			return .standardMedium_100px
		default:
			return .standardLarge_200px
		}
	}()
	
	init(charactersRepository: MarvelCharactersRepository) {
		self.charactersRepository = charactersRepository
		self.charactersOrder = .ascending
		setupSections()
		setupImageLoading()
	}
	
	private func setupSections() {
		switch self.charactersOrder {
		case .ascending:
			self.characterSections = CharacterSection.Initial.allSortedAscending.map { .init(initial: $0, characters: []) }
		case .descending:
			self.characterSections = CharacterSection.Initial.allSortedDescending.map { .init(initial: $0, characters: []) }
		}
	}
	
	func changeOrder() {
		cancelRequests()
		characterImagesController.cancelRequests()
		characterImagesController.cleanImagesByIndexPath()
		self.charactersCount = 0
		self.page = 0
		self.charactersOrder.toggle()
		setupSections()
		self.delegate?.reloadList()
		setupImageLoading()
		loadData()
	}
	
	func loadData() {
		guard paginatedCancellables[self.page] == nil else { return }
		DispatchQueue.main.async {
			self.delegate?.didStartLoading()
		}
		print("PAGE: \(self.page)")
		let request = charactersRepository.charactersSortedByNamePaginated(
			limit: Constants.charactersListPageSize,
			page: self.page,
			ascending: self.charactersOrder == .ascending
		)
		paginatedCancellables[self.page] = request.sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				DispatchQueue.main.async {
					self.delegate?.errorLoading(error)
				}
			case .finished:
				break
			}
		}, receiveValue: { (characters) in
			
			self.charactersCount += characters.count
			
			var indexPathsAndThumbnailsForNewCharacters: [(MarvelImage, IndexPath)] = []
			
			for character in characters {
				if let firstCharacter = character.name.first, !firstCharacter.isNumber {
					let characterInitial = String(firstCharacter).folding(options: .diacriticInsensitive, locale: nil).lowercased()
					let charactersSectionIndex = self.characterSections.firstIndex(where: { $0.initial.rawValue == characterInitial }) ?? 0
					self.characterSections[charactersSectionIndex].characters.append(character)
					
					let row = self.characterSections[charactersSectionIndex].characters.count
					indexPathsAndThumbnailsForNewCharacters.append((character.thumbnail, IndexPath(row: row - 1, section: charactersSectionIndex)))
				} else {
					self.characterSections[0].characters.append(character)
					let row = self.characterSections[0].characters.count
					indexPathsAndThumbnailsForNewCharacters.append((character.thumbnail, IndexPath(row: row - 1, section: 0)))
				}
			}
			
			if !characters.isEmpty {
				self.page += 1
			}
			
			DispatchQueue.main.async {
				self.delegate?.reloadList()
				
				indexPathsAndThumbnailsForNewCharacters.forEach {
					self.downloadThumbnail($0, forIndexPath: $1)
				}
				
				self.delegate?.didFinishLoading()
			}
		})
	}
	
	func downloadThumbnail(_ thumbnail: MarvelImage, forIndexPath indexPath: IndexPath) {
		self.characterImagesController.downloadImage(thumbnail.imageURL(withQuality: marvelImageThumbnailQuality), withCommonPath: thumbnail.path, forIndexPath: indexPath)
	}
	
	func thumbnail(forIndex indexPath: IndexPath, orPath imagePath: MarvelImage) -> UIImage? {
		return self.characterImagesController.imageFor(indexPath: indexPath) ?? self.imageThumbnail(forImagePath: imagePath)
	}
	
	func imageThumbnail(forImagePath imagePath: MarvelImage) -> UIImage? {
		return self.characterImagesController.imageFor(thumbnailURL: imagePath.imageURL(withQuality: marvelImageThumbnailQuality), path: imagePath.path)
	}
	
	func cancelRequests() {
		self.cancellables.forEach {
			$0.cancel()
		}
		self.paginatedCancellables.forEach {
			$0.value.cancel()
		}
		self.cancellables.removeAll(keepingCapacity: true)
		self.paginatedCancellables.removeAll(keepingCapacity: true)
	}
	
	// MARK: Convenience
	
	private func setupImageLoading() {
		let imagesControllerPublisher = self.characterImagesController.publisher.collect(.byTimeOrCount(DispatchQueue.main, .milliseconds(500), 10))
		self.cancellables.append(imagesControllerPublisher.receive(on: DispatchQueue.main).sink { (indexPathsToDelete) in
			self.delegate?.reloadRows(at: indexPathsToDelete)
		})
	}
	
	deinit {
		cancelRequests()
	}
}
