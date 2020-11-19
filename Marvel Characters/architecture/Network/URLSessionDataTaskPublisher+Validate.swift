//
//  URLSessionDataTask+Validate.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation
import Combine

extension Publisher where Output == (data: Data, response: URLResponse), Failure == URLError {
	func validate() -> AnyPublisher<Data, Failure> {
		return self.flatMap { (output) -> AnyPublisher<Data, Failure> in
			guard let httpResponse = output.response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
				if let httpResponse = output.response as? HTTPURLResponse {
					return Fail(error: URLError(URLError.Code(rawValue: httpResponse.statusCode))).eraseToAnyPublisher()
				}
				return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
			}
			return Just(output.data)
					.setFailureType(to: Failure.self)
					.eraseToAnyPublisher()
		}.eraseToAnyPublisher()
	}
}
