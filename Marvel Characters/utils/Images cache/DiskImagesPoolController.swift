//
//  DiskImagesPoolController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import struct CoreGraphics.CGFloat
import class Foundation.FileManager

class DiskImagesPoolController {
	
	private let diskImagesURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cachedImages")
	
	static let shared = DiskImagesPoolController()
	
	private init() {
		if !FileManager.default.fileExists(atPath: diskImagesURL.path) {
			try? FileManager.default.createDirectory(at: diskImagesURL, withIntermediateDirectories: false, attributes: nil)
		}
	}
	
	func saveImageDataOnDisk(imageData: Data, forURLPath path: String, withImageSize imageSize: CoreGraphics.CGFloat) {
		DispatchQueue.global(qos: .background).async {
			let finalPath = self.filePathOnDisk(forURLPath: path, withImageSize: imageSize)
			FileManager.default.createFile(atPath: finalPath, contents: imageData, attributes: nil)
		}
	}
	
	func retrieveSavedImageDataOnDisk(forURLPath path: String, withImageSize imageSize: CoreGraphics.CGFloat) -> Data? {
		let finalPath = filePathOnDisk(forURLPath: path, withImageSize: imageSize)
		return FileManager.default.contents(atPath: finalPath)
	}
	
	private func filePathOnDisk(forURLPath path: String, withImageSize imageSize: CoreGraphics.CGFloat) -> String {
		let hashedPath = "\(path)\(Int(imageSize.rounded()))".md5HexString()
		return self.diskImagesURL.appendingPathComponent(hashedPath).path
	}
}
