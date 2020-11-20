//
//  MarvelCharactersDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation
import Combine

class MarvelCharactersDataSource {
	
	private let router = MarvelCharactersRouter.self
	private let dataUtils = DataUtils()
	
	func characters(parameters: MarvelCharacterParameters) -> AnyPublisher<MarvelDataModel.CharacterDataWrapper, Error> {
		print("characters!!, parameters: \(parameters)")
		return self.router.characters(parameters: parameters).requestPublisher()
			.mapError { MarvelNetworkError.urlError($0) }
			.marvelAPIValidate()
			.decode(type: MarvelDataModel.CharacterDataWrapper.self, decoder: dataUtils.marvelJSONDecoder())
			.eraseToAnyPublisher()
	}

	func character(id: Int) -> AnyPublisher<MarvelDataModel.CharacterDataWrapper, Error> {
		self.router.character(id: id).requestPublisher()
			.mapError { MarvelNetworkError.urlError($0) }
			.marvelAPIValidate()
			.decode(type: MarvelDataModel.CharacterDataWrapper.self, decoder: dataUtils.marvelJSONDecoder())
			.eraseToAnyPublisher()
	}
}
