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
			if maximumItemsNeeded >= self.dataSource.snapshot().numberOfItems {
				self.dataSource.loadData()
			}
		}
	}
	
	private func flatIndex(for indexPath: IndexPath) -> Int {
		guard indexPath.section != 0 else {
			return indexPath.row
		}

		var counter = 0
		for section in 0...indexPath.section {
			if section == indexPath.section {
				counter += indexPath.row
			} else {
				let section = self.dataSource.snapshot().sectionIdentifiers[section]
				counter += self.dataSource.snapshot().numberOfItems(inSection: section)
			}
		}
		return counter
	}
}
