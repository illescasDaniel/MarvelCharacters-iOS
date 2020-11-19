//
//  CharacterDataContainer.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct CharacterDataContainer: Decodable {
		/// The requested offset (number of skipped results) of the call.
		let offset: Int
		/// The requested result limit.
		let limit: Int
		/// The total number of resources available given the current filter set.
		let total: Int
		/// The total number of results returned by this call.
		let count: Int
		/// The list of characters returned by the call
		let results: [MarvelCharacter]
	}
}
