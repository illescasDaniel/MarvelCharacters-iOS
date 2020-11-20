//
//  CharactersTableViewController+DataSourceDelegate.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

extension CharactersTableViewController: CharactersListDataSourceDelegate {
	
	func reloadList() {
		self.tableView.reloadData()
	}
	
	func reloadRow(index: Int) {
		self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
	
	func reloadRows(indices: [Int]) {
		self.tableView.reloadRows(at: indices.map({ IndexPath(row: $0, section: 0) }), with: .fade)
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
