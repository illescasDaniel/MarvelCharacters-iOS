//
//  EventSummary.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct EventSummary: Decodable {
		/// The path to the individual event resource.
		let resourceURI: String
		/// The name of the event.
		let name: String
	}
}
