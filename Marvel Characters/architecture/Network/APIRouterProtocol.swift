//
//  APIRouterProtocol.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation
import Combine

protocol APIRouter {
	
	var baseURL: URL { get }
	
	var path: String { get }
	var httpBody: Data? { get }
	var queryItems: [URLQueryItem]? { get }
	var httpMethod: HTTPMethod { get }
	
	func requestPublisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
}

extension APIRouter {
	
	func requestPublisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
		
		let url = self.path.isEmpty ? self.baseURL : self.baseURL.appendingPathComponent(self.path, isDirectory: false)
		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		}
		
		urlComponents.queryItems = self.queryItems
		
		guard let urlWithQueryItems = urlComponents.url else {
			return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
		}
		
		var urlRequest = URLRequest(url: urlWithQueryItems, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 60)
		urlRequest.httpMethod = self.httpMethod.rawValue
		urlRequest.httpBody = self.httpBody
		urlRequest.setValue(ContentType.json.rawValue,
							forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
		urlRequest.setValue(ContentType.json.rawValue,
							forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
		
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
			.eraseToAnyPublisher()
	}
}
