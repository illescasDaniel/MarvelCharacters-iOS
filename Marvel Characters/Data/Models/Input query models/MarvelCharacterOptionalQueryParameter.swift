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
	
	func setName(_ name: String) -> Self {
		return addQueryItem(name: "name", value: name)
	}
	
	/*
	case .nameStartsWith(prefix: let prefix):
		return .init(name: "nameStartsWith", value: prefix)
	case .modifiedSince(let date):
		let dateFormatter = DataUtils().marvelDateFormatter()
		return .init(name: "modifiedSince", value: dateFormatter.string(from: date))
	
	case .comics(let comicIds):
		return .init(name: "comics", value: comicIds.joinedIds())
	case .series(let serieIds):
		return .init(name: "series", value: serieIds.joinedIds())
	case .events(let eventIds):
		return .init(name: "events", value: eventIds.joinedIds())
	case .stories(let storyIds):
		return .init(name: "stories", value: storyIds.joinedIds())
	case .orderBy(let order):
		return .init(name: "orderBy", value: order.rawValue)
	case .limit(let limit):
		return .init(name: "limit", value: String(limit))
	case .offset(let offset):
		return .init(name: "offset", value: String(offset))
	*/
	
	func nameStartsWith(prefix: String) -> Self {
		return addQueryItem(name: "nameStartsWith", value: prefix)
	}
	
	func modifiedSince(_ date: Date) -> Self {
		let dateFormatter = DataUtils().marvelDateFormatter()
		return addQueryItem(name: "modifiedSince", value: dateFormatter.string(from: date))
	}
	
	func comics(_ ids: Int...) -> Self {
		return addQueryItem(name: "comics", value: joinedIds(ids))
	}
	
	func series(_ ids: Int...) -> Self {
		return addQueryItem(name: "series", value: joinedIds(ids))
	}
	
	func events(_ ids: Int...) -> Self {
		return addQueryItem(name: "events", value: joinedIds(ids))
	}
	
	func stories(_ ids: Int...) -> Self {
		return addQueryItem(name: "stories", value: joinedIds(ids))
	}
	
	func orderBy(_ order: Order) -> Self {
		return addQueryItem(name: "orderBy", value: order.rawValue)
	}
	
	func limit(_ limit: Int) -> Self {
		
		return self
	}
	
	func offset(_ offset: Int) -> Self {
		
		return self
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

//enum MarvelCharacterOptionalQueryParameter {
//	// Return only characters matching the specified full character name (e.g. Spider-Man).
//	case name(String)
//	/// Return characters with names that begin with the specified string (e.g. Sp).
//	case nameStartsWith(prefix: String)
//	/// Return only characters which have been modified since the specified date.
//	case modifiedSince(Date)
//	/// Return only characters which appear in the specified comics (accepts a comma-separated list of ids).
//	case comics(IdentifierList)
//	/// Return only characters which appear the specified series (accepts a comma-separated list of ids).
//	case series(IdentifierList)
//	/// Return only characters which appear in the specified events (accepts a comma-separated list of ids).
//	case events(IdentifierList)
//	/// Return only characters which appear the specified stories (accepts a comma-separated list of ids).
//	case stories(IdentifierList)
//	/// Order the result set by a field or fields. Add a "-" to the value sort in descending order. Multiple values are given priority in the order in which they are passed.
//	case orderBy(Order)
//	/// Limit the result set to the specified number of resources.
//	case limit(Int)
//	/// Skip the specified number of resources in the result set.
//	case offset(Int)
//}
