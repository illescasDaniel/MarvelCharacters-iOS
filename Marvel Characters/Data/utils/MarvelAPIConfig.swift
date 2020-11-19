//
//  MarvelAPIConfig.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

struct MarvelAPIConfig  {
	static let publicApiKey = String(cString: MarvelPublicAPIKey)
	static let privateApiKey = String(cString: MarvelPrivateAPIKey)
}
