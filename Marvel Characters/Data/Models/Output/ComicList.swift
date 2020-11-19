//
//  ComicList.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct ComicList: Decodable {
		/// The number of total available issues in this list. Will always be greater than or equal to the "returned" value.
		let available: Int
		/// The number of issues returned in this collection (up to 20).
		let returned: Int
		/// The path to the full list of issues in this collection.
		let collectionURI: String
		///  The list of returned issues in this collection.
		let items: [ComicSummary]
	}
}
