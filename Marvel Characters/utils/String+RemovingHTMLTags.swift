//
//  String+StripOutHTMLTags.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import Foundation

extension String {
	
	mutating func removeHTMLTags() {
		self = self.removingHTMLTags()
	}
	
	func removingHTMLTags() -> String {
		self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
	}
}
