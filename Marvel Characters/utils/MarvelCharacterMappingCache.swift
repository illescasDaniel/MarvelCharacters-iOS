//
//  MarvelCharacterMappingCache.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import Foundation

class MarvelCharacterMappingCache {
	
	private var cachedCharacterByID: [Int: MarvelCharacter] = [:]
	
	private init() {}
	
	static let shared = MarvelCharacterMappingCache()
	
	@inlinable
	func storeValue(_ character: MarvelCharacter, id: Int) {
		self.cachedCharacterByID[id] = character
	}
	
	@inlinable
	func value(forID id: Int) -> MarvelCharacter? {
		return cachedCharacterByID[id]
	}
}
