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
	func reloadRows(indices: [Int])
	func errorLoading(_ error: Error)
}

class CharactersListDataSource {
	
	weak var delegate: CharactersListDataSourceDelegate?
	
	private(set) var characters: [MarvelCharacter] = []
	private var page: Int = 0
	
	private let characterImagesController = CharacterImagesController(imagesSize: Constants.charactersRowImageSize)
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
		setupImageLoading()
	}
	
	func loadData() {
		guard paginatedCancellables[page] == nil else { return }
		print("PAGE: \(page)")
		let request = charactersRepository.charactersSortedByNamePaginated(limit: 20, page: page)
		paginatedCancellables[page] = request.receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				DispatchQueue.main.async {
					self.delegate?.errorLoading(error)
				}
			case .finished:
				break
			}
		}, receiveValue: { (characters) in
			
			let currentNumberOfCharacters = self.characters.count
			self.characters += characters
			for (characterToAddThumbnail, index) in zip(characters, currentNumberOfCharacters..<(currentNumberOfCharacters + characters.count)) {
				self.downloadThumbnail(characterToAddThumbnail.thumbnail, forIndex: index)
			}
			
			if !self.characters.isEmpty {
				self.page += 1
			}
			self.delegate?.reloadList()
		})
	}
	
	func downloadThumbnail(_ thumbnail: MarvelImage, forIndex: Int) {
		characterImagesController.downloadImage(thumbnail.imageURL(withQuality: marvelImageThumbnailQuality), forIndex: forIndex)
	}
	
	func thumbnail(forIndex index: Int) -> UIImage? {
		return characterImagesController.imageFor(index: index)
	}
	
	func cancelRequests() {
		cancellables.forEach {
			$0.cancel()
		}
		paginatedCancellables.forEach {
			$0.value.cancel()
		}
	}
	
	// MARK: Convenience
	
	private func setupImageLoading() {
		let imagesControllerPublisher = self.characterImagesController.publisher.collect(.byTimeOrCount(DispatchQueue.main, .milliseconds(500), 10))
		cancellables.append(imagesControllerPublisher.receive(on: DispatchQueue.main).sink { (rowIndicesToReload) in
			self.delegate?.reloadRows(indices: rowIndicesToReload)
		})
	}
	
	deinit {
		cancelRequests()
	}
}
