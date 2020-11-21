//
//  MarvelCharacter.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 19/11/20.
//

import Foundation

struct MarvelCharacter: Decodable, Equatable {
	/// The unique ID of the character resource.
	let id: Int
	/// The name of the character.
	let name: String
	/// A short bio or description of the character.
	let description: String
	/// A set of public web site URLs for the resource.
	let urls: [String]
	/// The representative image for this character.
	let thumbnail: MarvelImage
}

extension MarvelCharacter: Hashable {
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
}
