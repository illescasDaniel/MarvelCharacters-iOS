//
//  String+Clean.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import Foundation

extension String {
	
	mutating func clean() {
		self = self.cleaned()
	}
	
	func cleaned() -> String {
		self.trimmingCharacters(in: .whitespacesAndNewlines).removingHTMLTags()
	}
}
