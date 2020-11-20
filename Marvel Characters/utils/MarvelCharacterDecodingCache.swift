//
//  DecodingCache.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation

class MarvelCharacterDecodingCache {
	
	private var cachedCharacterByID: [Int: MarvelDataModel.MarvelCharacter] = [:]
	
	private init() {}
	
	static let shared = MarvelCharacterDecodingCache()
	
	@inlinable
	func storeValue(_ character: MarvelDataModel.MarvelCharacter, id: Int) {
		self.cachedCharacterByID[id] = character
	}
	
	@inlinable
	func value(forID id: Int) -> MarvelDataModel.MarvelCharacter? {
		return cachedCharacterByID[id]
	}
}
