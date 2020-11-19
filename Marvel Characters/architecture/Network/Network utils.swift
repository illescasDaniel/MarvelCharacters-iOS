//
//  HTTPMethod.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
	case delete = "DELETE"
	case option = "OPTION"
	case head = "HEAD"
}

enum HTTPHeaderField: String {
	case authentication = "Authorization"
	case contentType = "Content-Type"
	case acceptType = "Accept"
	case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
	case json = "application/json"
	// ...
}
