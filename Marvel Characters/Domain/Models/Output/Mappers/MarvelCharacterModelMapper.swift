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
		if Constants.useAgressiveCaching, let cachedCharacter = MarvelCharacterMappingCache.shared.value(forID: inputModel.id) {
			print("Using cached mapped model")
			return cachedCharacter
		}
		let mappedCharacter = MarvelCharacter(
			id: inputModel.id,
			name: inputModel.name.cleaned(),
			description: inputModel.description.cleaned(),
			urls: inputModel.urls.compactMap {
				let trimmedURL = $0.url.cleaned()
				return trimmedURL.isEmpty ? nil : trimmedURL
			},
			thumbnail: MarvelImage(path: inputModel.thumbnail.path.cleaned(), imageExtension: inputModel.thumbnail.imageExtension.cleaned())
		)
		MarvelCharacterMappingCache.shared.storeValue(mappedCharacter, id: inputModel.id)
		return mappedCharacter
	}
}
