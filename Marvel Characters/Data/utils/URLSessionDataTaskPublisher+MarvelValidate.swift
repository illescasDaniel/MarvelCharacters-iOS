//
//  URLSessionDataTaskPublisher+MarvelValidate.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 19/11/20.
//

import Foundation
import Combine
import ZippyJSON

extension Publisher where Output == (data: Data, response: URLResponse), Failure == MarvelNetworkError {
	func marvelAPIValidate() -> AnyPublisher<Data, Failure> {
		return self.flatMap { (output) -> AnyPublisher<Data, Failure> in
			guard let httpResponse = output.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
				if let marvelError = try? ZippyJSONDecoder().decode(MarvelError.self, from: output.data) {
					return Fail(error: .apiError(marvelError)).eraseToAnyPublisher()
				}
				if let httpResponse = output.response as? HTTPURLResponse {
					return Fail(error: .urlError(URLError(URLError.Code(rawValue: httpResponse.statusCode)))).eraseToAnyPublisher()
				}
				return Fail(error: .urlError(URLError(.badServerResponse))).eraseToAnyPublisher()
			}
			return Just(output.data)
					.setFailureType(to: Failure.self)
					.eraseToAnyPublisher()
		}.eraseToAnyPublisher()
	}
}
