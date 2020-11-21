//
//  Constants.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import struct CoreGraphics.CGFloat

enum Constants {
	static let charactersRowImageSize: CoreGraphics.CGFloat = 64
	static let searchCharactersRowImageSize: CoreGraphics.CGFloat = 32
	static let searchDebounceDelay: Swift.Int = 250
	static let useAgressiveCaching: Bool = true
	static let charactersListPageSize: Int = 20
}

extension Constants {
	enum SegueID: String {
		case characterDetail = "CharacterDetail"
	}
}

extension Constants {
	enum StoryboardViewControllerID: String {
		case characterDetail = "CharacterDetailViewController"
	}
}
