//
//  MarvelCharacterRouter.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation
import Combine

enum MarvelCharactersRouter {
	case characters(parameters: MarvelCharacterParameters)
	case character(id: Int)
}

//

extension MarvelCharactersRouter: APIRouter {
	
	var baseURL: URL {
		MarvelEndpoint.charactersAPIURL
	}
	
	var path: String {
		switch self {
		case .characters(parameters: _):
			return ""
		case .character(id: let id):
			return String(id)
		}
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .characters(parameters: _):
			return .get
		case .character(id: _):
			return .get
		}
	}
	
	var queryItems: [URLQueryItem]? {
		switch self {
		case .characters(parameters: let parameters):
			return parameters.urlQueryItems + DataUtils().apiKeyQueryItems()
		case .character(id: _):
			return DataUtils().apiKeyQueryItems()
		}
	}

	
	var httpBody: Data? {
		switch self {
		case .characters(parameters: _):
			return nil
		case .character(id: _):
			return nil
		}
	}
}
