//
//  ErrorOutput.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 19/11/20.
//

import Foundation

struct MarvelError: Error, Decodable {
	let code: String
	let message: String
}

enum MarvelNetworkError: Error {
	case urlError(URLError)
	case apiError(MarvelError)
}
