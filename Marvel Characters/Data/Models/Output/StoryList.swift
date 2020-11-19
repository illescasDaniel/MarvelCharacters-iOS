//
//  StoryList.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct StoryList: Decodable {
		/// The number of total available stories in this list. Will always be greater than or equal to the "returned" value.
		let available: Int
		/// The number of stories returned in this collection (up to 20).
		let returned: Int
		/// The path to the full list of stories in this collection.
		let collectionURI: String
		/// The list of returned stories in this collection.
		let items: [StorySummary]
	}
}
