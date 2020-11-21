//
//  MarvelDateFormatter.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation
#if canImport(ZippyJSON)
import ZippyJSON
#endif

class DataUtils {
	
	func marvelDateFormatter() -> DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter
	}
	
	#if canImport(ZippyJSON)
	func marvelJSONDecoder() -> ZippyJSONDecoder {
		let decoder = ZippyJSONDecoder()
		decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
			let container = try decoder.singleValueContainer()
			let dateString = try container.decode(String.self)
			let dateFormatter = self.marvelDateFormatter()
			return dateFormatter.date(from: dateString) ?? Date()
		})
		return decoder
	}
	#else
	func marvelJSONDecoder() -> JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
			let container = try decoder.singleValueContainer()
			let dateString = try container.decode(String.self)
			let dateFormatter = self.marvelDateFormatter()
			return dateFormatter.date(from: dateString) ?? Date()
		})
		return decoder
	}
	#endif
	
	func marvelJSONEncoder() -> JSONEncoder {
		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(self.marvelDateFormatter())
		return encoder
	}
	
	func apiKeyQueryItems() -> [URLQueryItem] {
		
		let timestamp = String(Date().timeIntervalSince1970)
		let hashedPrivateKeys = "\(timestamp)\(MarvelAPIConfig.privateApiKey)\(MarvelAPIConfig.publicApiKey)"
		let md5HexString = hashedPrivateKeys.md5HexString()
		
		return [
			URLQueryItem(name: "apikey", value: MarvelAPIConfig.publicApiKey),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "hash", value: md5HexString)
		]
	}
	
}
