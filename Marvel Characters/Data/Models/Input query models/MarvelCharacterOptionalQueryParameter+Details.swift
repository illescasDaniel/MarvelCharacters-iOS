//
//  MarvelCharacterOptionalQueryParameter+Details.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

//extension MarvelCharacterOptionalQueryParameter {
//	enum Order {
//		case descending(Field)
//		case ascending(Field)
//
//		enum Field: String {
//			case name
//			case modified
//		}
//	}
//}
//
//extension MarvelCharacterOptionalQueryParameter {
//	typealias IdentifierList = [Int]
//}
//
//fileprivate extension Array where Element == Int {
//	func joinedIds() -> String {
//		self.map(String.init).joined(separator: ",")
//	}
//}

extension MarvelCharacterParametersBuilder {
	enum Order {
		case descending(Field)
		case ascending(Field)
		
		enum Field: String {
			case name
			case modified
		}
	}
}

extension MarvelCharacterParametersBuilder.Order.Field: Hashable, Equatable {}
extension MarvelCharacterParametersBuilder.Order: RawRepresentable {
	init?(rawValue: String) {
		switch rawValue {
		case Self.ascending(.name).rawValue:
			self = .ascending(.name)
		case Self.descending(.name).rawValue:
			self = .descending(.name)
		case Self.ascending(.modified).rawValue:
			self = .ascending(.modified)
		case Self.descending(.modified).rawValue:
			self = .descending(.modified)
		default:
			return nil
		}
	}
	
	var rawValue: String {
		switch self {
		case .descending(let field):
			return "-\(field.rawValue)"
		case .ascending(let field):
			return field.rawValue
		}
	}
}

extension MarvelCharacterParametersBuilder.Order: Hashable, Equatable {}


//
//extension MarvelCharacterOptionalQueryParameter.Order.Field: Hashable, Equatable {}
//
//extension MarvelCharacterOptionalQueryParameter.Order: RawRepresentable {
//
//	init?(rawValue: String) {
//		switch rawValue {
//		case Self.ascending(.name).rawValue:
//			self = .ascending(.name)
//		case Self.descending(.name).rawValue:
//			self = .descending(.name)
//		case Self.ascending(.modified).rawValue:
//			self = .ascending(.modified)
//		case Self.descending(.modified).rawValue:
//			self = .descending(.modified)
//		default:
//			return nil
//		}
//	}
//
//	var rawValue: String {
//		switch self {
//		case .descending(let field):
//			return "-\(field.rawValue)"
//		case .ascending(let field):
//			return field.rawValue
//		}
//	}
//}
//
//extension MarvelCharacterOptionalQueryParameter.Order: Hashable, Equatable {}
//
//extension MarvelCharacterOptionalQueryParameter {
//	var queryItem: URLQueryItem {
//		switch self {
//		case .name(let name):
//			return .init(name: "name", value: name)
//		case .nameStartsWith(prefix: let prefix):
//			return .init(name: "nameStartsWith", value: prefix)
//		case .modifiedSince(let date):
//			let dateFormatter = DataUtils().marvelDateFormatter()
//			return .init(name: "modifiedSince", value: dateFormatter.string(from: date))
//		case .comics(let comicIds):
//			return .init(name: "comics", value: comicIds.joinedIds())
//		case .series(let serieIds):
//			return .init(name: "series", value: serieIds.joinedIds())
//		case .events(let eventIds):
//			return .init(name: "events", value: eventIds.joinedIds())
//		case .stories(let storyIds):
//			return .init(name: "stories", value: storyIds.joinedIds())
//		case .orderBy(let order):
//			return .init(name: "orderBy", value: order.rawValue)
//		case .limit(let limit):
//			return .init(name: "limit", value: String(limit))
//		case .offset(let offset):
//			return .init(name: "offset", value: String(offset))
//		}
//	}
//}
//
//extension MarvelCharacterOptionalQueryParameter: Hashable, Equatable {
//
//	static func == (lhs: MarvelCharacterOptionalQueryParameter, rhs: MarvelCharacterOptionalQueryParameter) -> Bool {
//		return lhs.queryItem == rhs.queryItem
//	}
//
//	func hash(into hasher: inout Hasher) {
//		hasher.combine(self.queryItem.hashValue)
//	}
//}
