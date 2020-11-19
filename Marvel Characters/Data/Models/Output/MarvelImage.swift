//
//  MarvelImage.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct MarvelImage: Decodable {
		/// The directory path of to the image.
		let path: String
		/// The file extension for the image.
		let `extension`: String
	}
}
