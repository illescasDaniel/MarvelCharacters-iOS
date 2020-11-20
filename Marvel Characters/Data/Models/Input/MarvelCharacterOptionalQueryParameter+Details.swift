//
//  MarvelCharacterOptionalQueryParameter+Details.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

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
