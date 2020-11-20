//
//  CharactersTableViewController+DataSourceDelegate.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

extension CharactersTableViewController: CharactersListDataSourceDelegate {
	
	func reloadList() {
		
	}
	
	func errorLoading(_ error: Error) {
		dump(error)
		
		let errorAlertController = UIAlertController(
			title: "Error",
			message: "Error while fetching characters.\nError Code:\((error as NSError).code)",
			preferredStyle: .alert
		)
		errorAlertController.addAction(.init(title: "OK", style: .default, handler: nil))
		self.present(errorAlertController, animated: true)
	}
	
}
