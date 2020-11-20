//
//  UIImage+Resize.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

extension UIImage {
	// base code from: https://stackoverflow.com/questions/31314412/how-to-resize-image-in-swift
	func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
		
		let width: CGFloat
		let height: CGFloat
		
		let size = self.size
		let aspectRatio =  size.width/size.height
		
		switch contentMode {
		case .scaleAspectFit:
			if aspectRatio > 1 {                            // Landscape image
				width = dimension
				height = dimension / aspectRatio
			} else {                                        // Portrait image
				height = dimension
				width = dimension * aspectRatio
			}
		case .scaleAspectFill:
			if aspectRatio > 1 {                            // Landscape image
				height = dimension
				width = dimension * aspectRatio
			} else {                                        // Portrait image
				width = dimension
				height = dimension / aspectRatio
			}
		default:
			assertionFailure("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
			return self
		}
		
		let renderFormat = UIGraphicsImageRendererFormat.default()
		renderFormat.opaque = opaque
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
		return renderer.image { (context) in
			self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
		}
	}
}
