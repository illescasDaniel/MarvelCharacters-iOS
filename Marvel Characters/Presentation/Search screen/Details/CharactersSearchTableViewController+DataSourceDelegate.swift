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
		guard let visibleRows = self.tableView.indexPathsForVisibleRows else { return }
		self.tableView.beginUpdates()
		let rowsToReload = Set(visibleRows).intersection(Set(indices.map({ IndexPath(row: $0, section: 0) })))
		self.tableView.reloadRows(at: Array(rowsToReload), with: .none)
		self.tableView.endUpdates()
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
