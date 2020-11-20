//
//  CharactersSearchTableViewController+UISearchResultUpdating.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

extension CharactersSearchTableViewController: UISearchResultsUpdating {
	
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
		dataSource.updateCharacters(searchText: searchText)
	}
}
