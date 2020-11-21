//
//  CharactersSearchTableViewController+DataSourceDelegate.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

extension CharactersSearchTableViewController: CharactersSearchListDataSourceDelegate {
	
	func reloadSearchListResults() {
		self.tableView.reloadData()
	}
	
	func reloadRows(indices: [Int]) {
		self.tableView.reloadRows(at: indices.map({ IndexPath(row: $0, section: 0) }), with: .none)
	}
	
	func errorWithSearchResults(_ error: Error) {
		
		dump(error)
		
		let errorAlertController = UIAlertController(
			title: "Error",
			message: "Error while performing search.\nError Code:\((error as NSError).code)",
			preferredStyle: .alert
		)
		errorAlertController.addAction(.init(title: "OK", style: .default, handler: nil))
		self.present(errorAlertController, animated: true)
	}
}
