//
//  MarvelEndpoint.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

enum MarvelEndpoint {
	
	static let baseURL = URL(string: "https://gateway.marvel.com:443")!
	static let baseAPIURL = MarvelEndpoint.baseURL.appendingPathComponent("v1/public")
	
	static let charactersAPIURL = MarvelEndpoint.baseAPIURL.appendingPathComponent("characters")
}
