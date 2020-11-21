//
//  File.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

enum Asset {
	static let placeholderImage = UIImage(named: "Placeholder")!.resizeImage(Constants.characterRowImageSize, opaque: false, contentMode: .scaleAspectFit)
	static let bigPlaceholderImage = UIImage(named: "Placeholder")!.resizeImage(Constants.characterDetailImageSize, opaque: false, contentMode: .scaleAspectFit)
	static let smallPlaceholderImage = UIImage(named: "Placeholder")!.resizeImage(Constants.characterInSearchResultRowImageSize, opaque: false, contentMode: .scaleAspectFit)
}
