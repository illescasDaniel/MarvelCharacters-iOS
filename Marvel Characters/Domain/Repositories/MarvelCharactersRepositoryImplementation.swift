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
	
	func downloadCharacterThumbnail(_ thumbnailURL: String) -> AnyPublisher<Data, URLError> {
		URLSession.shared.dataTaskPublisher(for: URL(string: thumbnailURL)!)
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
		let parameters = MarvelCharacterParameters.Builder()
			.limit(20)
			.nameStartsWith(prefix: namePrefix)
			.build()
		return dataSource.characters(parameters: parameters)
			.map(MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters)
			.throttle(for: .milliseconds(300), scheduler: RunLoop.main, latest: true)
			.eraseToAnyPublisher()
	}
}
