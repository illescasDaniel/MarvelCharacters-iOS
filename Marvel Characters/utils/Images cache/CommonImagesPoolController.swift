//
//  CommonImagesPoolController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import struct CoreGraphics.CGFloat
import class UIKit.UIImage

class CommonImagesPoolController {
	
	private var commonImagesPool: [String: [UIImage]] = [:]
	
	static let shared = CommonImagesPoolController()
	
	func save(image: UIImage, forURLPath path: String, withImageSize imageSize: CoreGraphics.CGFloat) {
		if let cachedImagesForURL = self.commonImagesPool[path] {
			if !cachedImagesForURL.contains(where: { $0.size.width == imageSize }) {
				self.commonImagesPool[path] = cachedImagesForURL + [image]
			}
		} else {
			self.commonImagesPool[path] = [image]
		}
	}
	
	func retrieveImage(forURLPath path: String, forImageSize imageSize: CoreGraphics.CGFloat) -> UIImage? {
		if let cachedImagesForURL = self.commonImagesPool[path], !cachedImagesForURL.isEmpty {
			if let cachedImageForSize = cachedImagesForURL.first(where: { $0.size.width == imageSize }) {
				print("used exact size image from common images pool")
				return cachedImageForSize
			}
			if let alternativeBiggerImage = cachedImagesForURL.first(where: { $0.size.width > imageSize }) {
				print("found bigger image in common images pool")
				let image = alternativeBiggerImage.resizeImage(imageSize, opaque: true, contentMode: .scaleAspectFill)
				self.commonImagesPool[path] = cachedImagesForURL + [image]
				return image
			}
		}
		return nil
	}
}
