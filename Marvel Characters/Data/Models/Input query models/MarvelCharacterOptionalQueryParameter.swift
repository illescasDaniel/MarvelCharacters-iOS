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

