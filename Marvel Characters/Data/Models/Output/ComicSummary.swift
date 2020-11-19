//
//  ComicSummary.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct ComicSummary: Decodable {
		/// The path to the individual comic resource.
		let resourceURI: String
		/// The canonical name of the comic.
		let name: String
	}
}
