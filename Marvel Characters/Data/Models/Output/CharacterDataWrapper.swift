//
//  CharacterDataWrapper.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct CharacterDataWrapper: Decodable {
		/// The HTTP status code of the returned result.
		let code: Int
		/// A string description of the call status
		let status: String
		/// The attribution notice for this result. Please display either this notice or the contents of the attributionHTML field on all screens which contain data from the Marvel Comics API.
		let attributionText: String
		/// An HTML representation of the attribution notice for this result. Please display either this notice or the contents of the attributionText field on all screens which contain data from the Marvel Comics API.,
		let attributionHTML: String
		/// The results returned by the call.
		let data: CharacterDataContainer
		/// A digest value of the content returned by the call
		let etag: String
	}
}
