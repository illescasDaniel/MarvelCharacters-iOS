//
//  SeriesSummary.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct SeriesSummary: Decodable {
		/// The path to the individual series resource.
		let resourceURI: String
		///  The canonical name of the series.
		let name: String
	}
}
