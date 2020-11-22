//
//  CharacterListDataSource+CharactersSection.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import Foundation

extension CharactersListDataSource {
	struct CharacterSection {
		
		enum Initial: String, CaseIterable {
			case numbers
			case a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, w, x, y, z
			
			static var allSortedAscending: [Initial] {
				[.numbers, .a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l,
				 .m, .n, .o, .p, .q, .r, .s, .t, .u, .w, .x, .y, .z]
			}
			
			static var allSortedDescending: [Initial] {
				allSortedAscending.reversed()
			}
		}
		
		let initial: Initial
		var characters: [MarvelCharacter]
	}
}


extension CharactersListDataSource.CharacterSection.Initial: CustomStringConvertible {
	var description: String {
		switch self {
		case .numbers:
			return "0-9"
		default:
			return self.rawValue.uppercased()
		}
	}
}
