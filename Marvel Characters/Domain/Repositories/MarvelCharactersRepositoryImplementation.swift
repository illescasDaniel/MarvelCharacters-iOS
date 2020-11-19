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
}
