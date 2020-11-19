//
//  StorySummary.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct StorySummary: Decodable {
		/// The path to the individual story resource.
		let resourceURI: String
		/// The canonical name of the story.
		let name: String
		/// The type of the story (interior or cover).
		let type: String
	}
}
