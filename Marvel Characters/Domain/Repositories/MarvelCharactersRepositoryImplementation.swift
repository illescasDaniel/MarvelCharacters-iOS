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
	private var cachedSearches: [String: [MarvelCharacter]] = [:]
	
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
	
	func charactersSortedByNamePaginated(limit: Int, page: Int) -> AnyPublisher<[MarvelCharacter], Error> {
		let parameters = MarvelCharacterParameters.Builder()
			.limit(limit)
			.offset(limit * page)
			.orderBy(.ascending(.name))
			.build()
		return dataSource.characters(parameters: parameters)
			.map(MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters)
			.eraseToAnyPublisher()
	}
	
	func searchCharacters(startingWith namePrefix: String) -> AnyPublisher<[MarvelCharacter], Error> {
		
		if let cachedResponse = self.cachedSearches[namePrefix] {
			print("Using cached response")
			return Just(cachedResponse).setFailureType(to: Error.self).eraseToAnyPublisher()
		}
		
		let parameters = MarvelCharacterParameters.Builder()
			.limit(20)
			.nameStartsWith(prefix: namePrefix)
			.build()
		return dataSource.characters(parameters: parameters)
			.map { (originalData) -> [MarvelCharacter] in
				let mappedData = MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters(originalData)
				self.cachedSearches[namePrefix] = mappedData
				return mappedData
			}
			.eraseToAnyPublisher()
	}
}
