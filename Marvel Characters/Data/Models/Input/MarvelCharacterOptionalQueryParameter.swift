//
//  MarvelCharacterOptionalQueryParameter.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

struct MarvelCharacterParameters {
	typealias Builder = MarvelCharacterParametersBuilder
	let urlQueryItems: [URLQueryItem]
}

class MarvelCharacterParametersBuilder {
	
	private var urlQueryItems: [URLQueryItem] = []
	
	/// Return only characters matching the specified full character name (e.g. Spider-Man).
	func setName(_ name: String) -> Self {
		return addQueryItem(name: "name", value: name)
	}
	
	/// Return characters with names that begin with the specified string (e.g. Sp). (The search is case insensitive)
	func nameStartsWith(prefix: String) -> Self {
		return addQueryItem(name: "nameStartsWith", value: prefix)
	}
	
	/// Return only characters which have been modified since the specified date.
	func modifiedSince(_ date: Date) -> Self {
		let dateFormatter = DataUtils().marvelDateFormatter()
		return addQueryItem(name: "modifiedSince", value: dateFormatter.string(from: date))
	}
	
	/// Return only characters which appear in the specified comics.
	func comics(_ ids: Int...) -> Self {
		return addQueryItem(name: "comics", value: joinedIds(ids))
	}
	
	/// Return only characters which appear the specified series.
	func series(_ ids: Int...) -> Self {
		return addQueryItem(name: "series", value: joinedIds(ids))
	}
	
	/// Return only characters which appear in the specified events.
	func events(_ ids: Int...) -> Self {
		return addQueryItem(name: "events", value: joinedIds(ids))
	}
	
	/// Return only characters which appear the specified stories.
	func stories(_ ids: Int...) -> Self {
		return addQueryItem(name: "stories", value: joinedIds(ids))
	}
	
	/// Order the result set by a field or fields.
	func orderBy(_ order: Order) -> Self {
		return addQueryItem(name: "orderBy", value: order.rawValue)
	}
	
	/// Limit the result set to the specified number of resources.
	func limit(_ limit: Int) -> Self {
		return addQueryItem(name: "limit", value: String(limit))
	}
	
	/// Skip the specified number of resources in the result set.
	func offset(_ offset: Int) -> Self {
		return addQueryItem(name: "offset", value: String(offset))
	}
	
	func page(_ page: Int, limit: Int) -> Self {
		self.limit(limit)
			.offset(page * limit)
	}
	
	//
	
	func build() -> MarvelCharacterParameters {
		return MarvelCharacterParameters(urlQueryItems: self.urlQueryItems)
	}
	
	//
	
	private func addQueryItem(name: String, value: String?) -> Self {
		self.urlQueryItems.append(URLQueryItem(name: name, value: value))
		return self
	}
	
	private func joinedIds(_ ids: [Int]) -> String {
		ids.map(String.init).joined(separator: ",")
	}
}

