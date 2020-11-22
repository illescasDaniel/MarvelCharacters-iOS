//
//  CharacterSection.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 22/11/20.
//

import Foundation

enum CharacterSection: String {
	
	case numbers = "0-9"
	case a = "A", b = "B", c = "C", d = "D", e = "E", f = "F", g = "G", h = "H", i = "I", j = "J",
		 k = "K", l = "L", m = "M", n = "N", o = "O", p = "P", q = "Q", r = "R", s = "S", t = "T",
		 u = "U", w = "W", x = "X", y = "Y", z = "Z"
	
	static var allSortedAscending: [CharacterSection] {
		[.numbers, .a, .b, .c, .d, .e, .f, .g, .h, .i, .j, .k, .l,
		 .m, .n, .o, .p, .q, .r, .s, .t, .u, .w, .x, .y, .z]
	}
	
	static var allSortedDescending: [CharacterSection] {
		allSortedAscending.reversed()
	}
}
