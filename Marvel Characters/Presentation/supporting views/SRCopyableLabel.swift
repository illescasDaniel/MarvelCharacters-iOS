//
//  SRCopyableLabel.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import UIKit

// based on: https://stephenradford.me/make-uilabel-copyable/

class SRCopyableLabel: UILabel {

	override public var canBecomeFirstResponder: Bool {
		return true
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		sharedInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
	}

	func sharedInit() {
		self.isUserInteractionEnabled = true
		addGestureRecognizer(UILongPressGestureRecognizer(
			target: self,
			action: #selector(showMenu(sender:))
		))
	}

	override func copy(_ sender: Any?) {
		UIPasteboard.general.string = text
		if #available(iOS 13.0, *) {
			UIMenuController.shared.hideMenu()
		} else {
			UIMenuController.shared.setMenuVisible(false, animated: true)
		}
	}

	@objc private func showMenu(sender: Any?) {
		becomeFirstResponder()
		let menu = UIMenuController.shared
		if menu.isMenuVisible { return }
		if #available(iOS 13.0, *) {
			menu.showMenu(from: self, rect: bounds)
		} else {
			menu.setTargetRect(bounds, in: self)
			menu.setMenuVisible(true, animated: true)
		}
	}

	override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		return (action == #selector(copy(_:)))
	}
}
