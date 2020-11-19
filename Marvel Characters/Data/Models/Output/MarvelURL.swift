//
//  MarvelURL.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct MarvelURL: Decodable {
		/// A text identifier for the URL.
		let type: String
		/// A full URL (including scheme, domain, and path).
		let url: String
	}
}
