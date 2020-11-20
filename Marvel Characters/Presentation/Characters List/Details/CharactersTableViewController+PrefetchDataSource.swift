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
	}

	func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		print("cancel prefetching for rows at \(indexPaths)")
	}
}
