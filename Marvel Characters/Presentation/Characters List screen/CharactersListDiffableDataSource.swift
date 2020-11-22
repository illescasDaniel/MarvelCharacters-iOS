//
//  CharactersListDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation
import Combine
import UIKit

protocol CharactersListDataSourceDelegate: class {
	func didStartLoading()
	func didFinishLoading()
	func errorLoading(_ error: Error)
}

class CharactersListDiffableDataSource: UITableViewDiffableDataSource<CharacterSection, MarvelCharacter> {
	
	// MARK: Properties
	
	weak var delegate: CharactersListDataSourceDelegate?
	
	private var charactersOrder: CharactersOrder = .ascending
	
	private var page: Int = 0
	
	private let characterImagesController = CharacterImagesController(imagesSize: Constants.characterRowImageSize)
	private var paginatedCancellables: [Int: AnyCancellable] = [:]
	private var cancellables: [AnyCancellable] = []
	
	private let charactersRepository: MarvelCharactersRepository
	
	private let changeListOrderPublisher = PassthroughSubject<(), Never>()
	
	// MARK: Life cycle
	
	init(charactersRepository: MarvelCharactersRepository, tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<CharacterSection, MarvelCharacter>.CellProvider) {

		self.charactersRepository = charactersRepository
		self.charactersOrder = .ascending
		
		super.init(tableView: tableView, cellProvider: cellProvider)
		
		setupSubscribers()
	}
	
	override init(tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<CharacterSection, MarvelCharacter>.CellProvider) {
		fatalError("Not implemented")
	}
	
	deinit {
		cancelRequests()
	}
	
	// MARK: Tableview Data source
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let aSnapshot = snapshot()
		let sectionValue = aSnapshot.sectionIdentifiers[section]
		return aSnapshot.numberOfItems(inSection: sectionValue) == 0 ? nil : sectionValue.rawValue
	}
	
	// MARK: Public methods
	
	func changeOrder() {
		self.changeListOrderPublisher.send()
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
			if case .failure(let error) = completion {
				DispatchQueue.main.async {
					self.delegate?.errorLoading(error)
				}
			}
		}, receiveValue: { (characters) in
			
			var snapshot = self.snapshot()
			var dataToInsert: [CharacterSection: [MarvelCharacter]] = [:]
			
			for character in characters {
				
				if let firstCharacter = character.name.first, !firstCharacter.isNumber {
					let characterInitial = String(firstCharacter).folding(options: .diacriticInsensitive, locale: nil).uppercased()
					let sectionForInitial = snapshot.sectionIdentifiers.first(where: { $0.rawValue == characterInitial }) ?? .numbers
					if let characters = dataToInsert[sectionForInitial] {
						dataToInsert[sectionForInitial] = characters + [character]
					} else {
						dataToInsert[sectionForInitial] = [character]
					}
				} else {
					if let characters = dataToInsert[.numbers] {
						dataToInsert[.numbers] = characters + [character]
					} else {
						dataToInsert[.numbers] = [character]
					}
				}
			}
			
			for (section, characters) in dataToInsert {
				snapshot.appendItems(characters, toSection: section)
			}
			
			if characters.count == Constants.charactersListPageSize {
				self.page += 1
			}

			DispatchQueue.main.async {
				self.apply(snapshot)
				
				characters.forEach {
					self.downloadThumbnail(forCharacter: $0)
				}

				self.delegate?.didFinishLoading()
			}
		})
	}
	
	func downloadThumbnail(forCharacter character: MarvelCharacter) {
		self.characterImagesController.downloadImage(for: character, thumbnailURL: character.thumbnail.imageURL(withQuality: marvelImageThumbnailQuality))
	}
	
	func thumbnail(forCharacter character: MarvelCharacter) -> UIImage? {
		self.characterImagesController.imageFor(character: character)
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
	
	private let marvelImageThumbnailQuality: MarvelImage.ThumbnailQuality = {
		switch UIScreen.main.scale {
		case 1:
			return .standardMedium_100px
		default:
			return .standardLarge_200px
		}
	}()
	
	private func _changeOrder() {
		cancelRequests()
		characterImagesController.cancelRequests()
		var snapshot = self.snapshot()
		snapshot.deleteAllItems()
		switch self.charactersOrder {
		case .ascending:
			snapshot.deleteSections(CharacterSection.allSortedAscending)
		case .descending:
			snapshot.deleteSections(CharacterSection.allSortedDescending)
		}
		self.apply(snapshot)
		self.page = 0
		self.charactersOrder.toggle()
		setupSubscribers()
		loadData()
	}
	
	// MARK: Subscribers setup
	
	private func setupSubscribers() {
		setupChangeListOrder()
		setupSections()
		setupImageLoading()
	}
	
	private func setupChangeListOrder() {
		changeListOrderPublisher
			.throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
			.sink { self._changeOrder() }
			.store(in: &cancellables)
	}
	
	private func setupSections() {
		var snapshot = self.snapshot()
		switch self.charactersOrder {
		case .ascending:
			snapshot.appendSections(CharacterSection.allSortedAscending)
		case .descending:
			snapshot.appendSections(CharacterSection.allSortedDescending)
		}
		self.apply(snapshot)
	}
	
	private func setupImageLoading() {
		
		let imagesControllerPublisher = self.characterImagesController.charactersPublisher.collect(.byTimeOrCount(DispatchQueue.global(qos: .userInteractive), .seconds(1), 20))//.collect(.byTime(DispatchQueue.global(qos: .userInteractive), .milliseconds(300)))
		
		imagesControllerPublisher.map({ Array(Set($0)) }).sink { (charactersToReload) in
			var currentSnapshot = self.snapshot()
			currentSnapshot.reloadItems(charactersToReload)
			DispatchQueue.main.async {
				self.apply(currentSnapshot)
			}
		}
		.store(in: &cancellables)
	}
}

extension CharactersListDiffableDataSource {
	enum CharactersOrder {
		case ascending, descending
		func opposite() -> CharactersOrder {
			self == .ascending ? .descending : .ascending
		}
		mutating func toggle() {
			self = opposite()
		}
	}
}
