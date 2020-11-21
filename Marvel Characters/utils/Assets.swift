//
//  File.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

enum Asset {
	static let placeholderImage = UIImage(named: "Placeholder")?.resizeImage(Constants.charactersRowImageSize, opaque: false, contentMode: .scaleAspectFit)
	static let smallPlaceholderImage = UIImage(named: "Placeholder")?.resizeImage(Constants.searchCharactersRowImageSize, opaque: false, contentMode: .scaleAspectFit)
}
