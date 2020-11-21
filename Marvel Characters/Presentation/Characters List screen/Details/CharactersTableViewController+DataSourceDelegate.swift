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
		if !Other.attributionText.isEmpty && Other.attributionText != self.navigationItem.prompt {
			self.navigationItem.prompt = Other.attributionText
		}
	}
	
	func reloadRow(index: Int) {
		self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
	
	func reloadRows(at indexPaths: [IndexPath]) {
		self.tableView.reloadRows(at: indexPaths, with: .none)
	}
	
	func errorLoading(_ error: Error) {
		dump(error)
		
		let errorAlertController = UIAlertController(
			title: NSLocalizedString("Error", comment: "Generic error"),
			message: String(format: NSLocalizedString("Error while fetching characters.\nError Code: %d", comment: "Error fetching marvel character"), (error as NSError).code),
			preferredStyle: .alert
		)
		errorAlertController.addAction(.init(title: NSLocalizedString("OK", comment: "Generic OK message"), style: .default, handler: nil))
		self.present(errorAlertController, animated: true)
	}
	
	func didStartLoading() {
		if let activityIndicator = self.navigationItem.leftBarButtonItem?.customView as? UIActivityIndicatorView {
			activityIndicator.startAnimating()
		} else {
			let activityIndicator = UIActivityIndicatorView(style: .medium)
			activityIndicator.hidesWhenStopped = true
			self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityIndicator)
			activityIndicator.startAnimating()
		}
	}
	
	func didFinishLoading() {
		if let activityIndicator = self.navigationItem.leftBarButtonItem?.customView as? UIActivityIndicatorView {
			activityIndicator.stopAnimating()
		}
	}
}
