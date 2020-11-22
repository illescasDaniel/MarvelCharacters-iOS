//
//  MarvelCharactersRepositoryImplementation.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 19/11/20.
//

import Foundation
import Combine

class MarvelCharactersRepositoryImplementation: MarvelCharactersRepository {
	
	private let dataSource = MarvelCharactersDataSource()
	private var cachedSearches: [CachedSearch: [MarvelCharacter]] = [:]
	
	private struct CachedSearch: Hashable {
		let searchText: String
		let page: Int
		func hash(into hasher: inout Hasher) {
			hasher.combine(searchText)
			hasher.combine(page)
		}
	}
	
	func character(id: Int) -> AnyPublisher<MarvelCharacter, Error> {
		dataSource.character(id: id)
			.map(MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacter)
			.eraseToAnyPublisher()
	}
	
	func characters(parameters: MarvelCharacterParameters) -> AnyPublisher<[MarvelCharacter], Error> {
		dataSource.characters(parameters: parameters)
			.map(MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters)
			.eraseToAnyPublisher()
	}
	
	func downloadCharacterThumbnail(_ thumbnailURL: URL) -> AnyPublisher<Data, URLError> {
		URLSession.shared.dataTaskPublisher(for: thumbnailURL)
			.validate()
			.eraseToAnyPublisher()
	}
	
	//
	
	func charactersSortedByNamePaginated(limit: Int, page: Int, ascending: Bool) -> AnyPublisher<[MarvelCharacter], Error> {
		let parameters = MarvelCharacterParameters.Builder()
			.limit(limit)
			.offset(limit * page)
			.orderBy(ascending ? .ascending(.name) : .descending(.name))
			.build()
		return dataSource.characters(parameters: parameters)
			.map(MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters)
			.eraseToAnyPublisher()
	}
	
	/// The search is case insensitive
	func searchCharactersPaginated(startingWith namePrefix: String, limit: Int, page: Int) -> AnyPublisher<[MarvelCharacter], Error> {
		
		if let cachedResponse = self.cachedSearches[CachedSearch(searchText: namePrefix, page: page)] {
			print("Using cached response")
			return Just(cachedResponse).setFailureType(to: Error.self).eraseToAnyPublisher()
		}
		
		let parameters = MarvelCharacterParameters.Builder()
			.page(page, limit: limit)
			.nameStartsWith(prefix: namePrefix)
			.orderBy(.ascending(.name))
			.build()
		
		return dataSource.characters(parameters: parameters)
			.map { (originalData) -> [MarvelCharacter] in
				let mappedData = MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters(originalData)
				self.cachedSearches[CachedSearch(searchText: namePrefix, page: page)] = mappedData
				return mappedData
			}
			.eraseToAnyPublisher()
	}
}
