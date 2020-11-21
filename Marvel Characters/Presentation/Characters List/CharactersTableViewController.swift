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
		navigationItem.prompt = "Data provided by Marvel. © 2020 MARVEL" // TODO: use the returned text instead ?
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
		return dataSource.characterSections.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource.characterSections[section].characters.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell

		let character = dataSource.characterSections[indexPath.section].characters[indexPath.row]
		
		cell.characterNameLabel.text = character.name
		
		if character.description.isEmpty {
			cell.characterDescriptionLabel.text = nil
			cell.characterDescriptionLabel.isHidden = true
		} else {
			cell.characterDescriptionLabel.isHidden = false
			cell.characterDescriptionLabel.text = self.view.frame.width > 1200 ? String(character.description.prefix(500)) : String(character.description.prefix(300))
		}
		
		if let thumbnail = dataSource.imageThumbnail(forImagePath: character.thumbnail) {
			cell.characterThumbnailImageView.image = thumbnail
		} else {
			cell.characterThumbnailImageView.image = Asset.placeholderImage
			dataSource.downloadThumbnail(character.thumbnail, forIndexPath: indexPath)
		}
		
		return cell
	}
	
	func flatIndex(for indexPath: IndexPath) -> Int {
		
		guard indexPath.section != 0 else {
			return indexPath.row
		}
		
		var counter = 0
		for section in 0...indexPath.section {
			if section == indexPath.section {
				counter += indexPath.row
			} else {
				counter += dataSource.characterSections[section].characters.count
			}
		}
		return counter
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let charactersSection = dataSource.characterSections[section]
		if charactersSection.characters.isEmpty {
			return nil
		}
		return charactersSection.initial.displayString
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		// reached bottom
		if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
			dataSource.loadData()
		}
	}
	
//	override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//		let maximumItemsNeeded = (indexPath.section + 1) * (indexPath.row + 1)
//		if dataSource.charactersCount <= maximumItemsNeeded {
//			dataSource.loadData()
//		}
//	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destination.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
