//
//  MarvelCharacterModelMapper.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 19/11/20.
//

import Foundation

class MarvelCharacterModelMapper {
	
	static func mapCharacterDataWrapperToCharacter(_ inputModel: MarvelDataModel.CharacterDataWrapper) -> MarvelCharacter {
		let character = inputModel.data.results.first!
		return mapDataCharacterToCharacter(character)
	}
	
	static func mapCharacterDataWrapperToCharacters(_ inputModel: MarvelDataModel.CharacterDataWrapper) -> [MarvelCharacter] {
		let characters = inputModel.data.results
		return characters.map(mapDataCharacterToCharacter)
	}
	
	static func mapDataCharacterToCharacter(_ inputModel: MarvelDataModel.MarvelCharacter) -> MarvelCharacter {
		return MarvelCharacter(
			id: inputModel.id,
			name: inputModel.name.trimmingCharacters(in: .whitespacesAndNewlines),
			description: inputModel.description.trimmingCharacters(in: .whitespacesAndNewlines),
			urls: inputModel.urls.compactMap {
				let trimmedURL = $0.url.trimmingCharacters(in: .whitespacesAndNewlines)
				return trimmedURL.isEmpty ? nil : trimmedURL
			},
			thumbnail: "\(inputModel.thumbnail.path).\(inputModel.thumbnail.extension)".trimmingCharacters(in: .whitespacesAndNewlines)
		)
	}
}
