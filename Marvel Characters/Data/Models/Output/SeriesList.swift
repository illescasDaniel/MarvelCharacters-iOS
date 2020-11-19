//
//  SeriesList.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct SeriesList: Decodable {
		/// The number of total available series in this list. Will always be greater than or equal to the "returned" value.
		let available: Int
		/// The number of series returned in this collection (up to 20).
		let returned: Int
		/// The path to the full list of series in this collection.
		let collectionURI: String
		/// The list of returned series in this collection.
		let items: [SeriesSummary]
	}
}
