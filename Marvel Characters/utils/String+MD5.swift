//
//  String+MD5.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import Foundation
import enum CryptoKit.Insecure

extension String {
	func md5HexString() -> String {
		let digest = Insecure.MD5.hash(data: Data(self.utf8))
		return digest.map {
			String(format: "%02hhx", $0)
		}.joined()
	}
}
