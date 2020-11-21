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
	
	func reloadRows(at indexPaths: [IndexPath]) {
		self.tableView.reloadRows(at: indexPaths, with: .none)
//		guard let visibleRows = self.tableView.indexPathsForVisibleRows else { return }
//		self.tableView.beginUpdates()
//		let rowsToReload = Set(visibleRows).intersection(Set(indices.map({ IndexPath(row: $0, section: 0) })))
//		self.tableView.reloadRows(at: Array(rowsToReload), with: .none)
//		self.tableView.endUpdates()
	}
	
	func errorWithSearchResults(_ error: Error) {
		
		dump(error)
		
		let errorAlertController = UIAlertController(
			title: NSLocalizedString("Error", comment: "Generic error"),
			message: String(format: NSLocalizedString("Error while performing search.\nError Code: %d", comment: "Error message when searching for marvel characters"), (error as NSError).code),
			preferredStyle: .alert
		)
		errorAlertController.addAction(.init(title: NSLocalizedString("OK", comment: "Generic OK message"), style: .default, handler: nil))
		self.present(errorAlertController, animated: true)
	}
}
