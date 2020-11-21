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
		guard let lastRow = indexPaths.max() else { return }
		DispatchQueue.global(qos: .background).async {
			let maximumItemsNeeded = self.flatIndex(for: lastRow) + 1
			if self.dataSource.charactersCount <= maximumItemsNeeded {
				self.dataSource.loadData()
			}
		}
	}
}
