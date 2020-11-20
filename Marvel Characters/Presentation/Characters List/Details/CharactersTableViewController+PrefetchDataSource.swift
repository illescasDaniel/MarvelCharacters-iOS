//
//  CharactersTableViewController+PrefetchDataSource.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

extension CharactersTableViewController: UITableViewDataSourcePrefetching {
	
	func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		print("prefetch rows at \(indexPaths)")
		guard let lastRow = indexPaths.last?.row else { return }
		let maximumItemsNeeded = lastRow + 1
		if dataSource.characters.count <= maximumItemsNeeded {
			dataSource.loadData()
		}
	}
}
