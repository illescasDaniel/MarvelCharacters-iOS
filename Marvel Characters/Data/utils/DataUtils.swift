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
import CryptoKit

class DataUtils {
	
	func marvelDateFormatter() -> DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS"
		return dateFormatter
	}
	
	#if canImport(ZippyJSON)
	func marvelJSONDecoder() -> ZippyJSONDecoder {
		let decoder = ZippyJSONDecoder()
		decoder.dateDecodingStrategy = .formatted(self.marvelDateFormatter())
		return decoder
	}
	#else
	func marvelJSONDecoder() -> JSONDecoder {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(self.marvelDateFormatter())
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
		let md5HexString = MD5(string: hashedPrivateKeys)
		
		return [
			URLQueryItem(name: "apikey", value: MarvelAPIConfig.publicApiKey),
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "hash", value: md5HexString)
		]
	}
	
	private func MD5(string: String) -> String {
		let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

		return digest.map {
			String(format: "%02hhx", $0)
		}.joined()
	}
}
