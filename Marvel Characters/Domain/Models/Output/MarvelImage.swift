//
//  MarvelImage.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import Foundation

struct MarvelImage: Decodable, Equatable {
	/// The directory path of to the image.
	let path: String
	/// The file extension for the image.
	let imageExtension: String
}

extension MarvelImage {
	
	enum ThumbnailQuality: String {
		case original = ""
		case standardMedium_100px = "standard_medium"
		case standardFantastic_250px = "standard_fantanstic"
		case landscapeLarge_270x200px = "landscape_xlarge"
		case standardLarge_200px = "standard_xlarge"
		case landscapeSmall_120x90px = "landscape_small"
		case standardSmall_65x45px = "standard_small"
		case standardLarge_140x140px = "standard_large"
	}
	
	@inlinable
	func imageURL(withQuality quality: ThumbnailQuality) -> String {
		if quality == .original {
			return "\(path).\(imageExtension)"
		}
		return "\(path)/\(quality.rawValue).\(imageExtension)"
	}
}
