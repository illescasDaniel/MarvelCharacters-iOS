//
//  CharacterDetailTableViewController+DataSourceDelegate.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import UIKit

extension CharacterDetailTableViewController: CharactersDetailDataSourceDelegate {
	
	func didLoadCharacterImage(_ image: UIImage) {
		UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve) {
			self.characterImageView.image = image
		}
	}
	
	func errorLoadingImage(_ error: Error) {
		
	}
}
