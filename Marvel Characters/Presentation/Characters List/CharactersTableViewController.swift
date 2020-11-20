//
//  CharactersTableViewController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

class CharactersTableViewController: UITableViewController {
	
	let dataSource = CharactersListDataSource(charactersRepository: MarvelCharactersRepositoryImplementation())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		dataSource.delegate = self
		
		title = "Marvel Characters"
		navigationItem.largeTitleDisplayMode = .always
		navigationController?.navigationBar.prefersLargeTitles = true
		
		tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: .main), forCellReuseIdentifier: "characterCell")
		
		dataSource.loadData()
		
		let searchController = CharactersSearchTableViewController(nibName: "CharactersSearchTableViewController", bundle: .main)
		navigationItem.searchController = UISearchController(searchResultsController: searchController)
		navigationItem.searchController?.searchResultsUpdater = searchController
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.characters.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell
		
		let character = dataSource.characters[indexPath.row]
		cell.characterNameLabel.text = character.name
		
		if character.description.isEmpty {
			cell.characterDescriptionLabel.text = nil
			cell.characterDescriptionLabel.isHidden = true
		} else {
			cell.characterDescriptionLabel.isHidden = false
			cell.characterDescriptionLabel.text = self.view.frame.width > 1200 ? String(character.description.prefix(500)) : String(character.description.prefix(300))
		}
		
		if let thumbnail = dataSource.thumbnail(forIndex: indexPath.row) {
			cell.characterThumbnailImageView.image = thumbnail
		} else {
			cell.characterThumbnailImageView.image = Asset.placeholderImage
			dataSource.downloadThumbnail(character.thumbnail, forIndex: indexPath.row)
		}
		
		return cell
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
