//
//  MarvelCharactersRepository.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 19/11/20.
//

import Foundation
import Combine

protocol MarvelCharactersRepository {
	func character(id: Int) -> AnyPublisher<MarvelCharacter, Error>
	func characters(parameters: MarvelCharacterParameters) -> AnyPublisher<[MarvelCharacter], Error>
	
	func downloadCharacterThumbnail(_ thumbnailURL: URL) -> AnyPublisher<Data, URLError>
	func charactersSortedByNamePaginated(limit: Int, page: Int, ascending: Bool) -> AnyPublisher<[MarvelCharacter], Error>
	func searchCharactersPaginated(startingWith namePrefix: String, limit: Int, page: Int) -> AnyPublisher<[MarvelCharacter], Error>
}
