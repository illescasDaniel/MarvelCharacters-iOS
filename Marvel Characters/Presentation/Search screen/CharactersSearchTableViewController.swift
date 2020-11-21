//
//  CharactersSearchTableViewController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

class CharactersSearchTableViewController: UITableViewController {
	
	let dataSource = CharactersSearchListDataSource(charactersRepository: MarvelCharactersRepositoryImplementation())
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = falsess
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		self.dataSource.delegate = self
		self.tableView.register(UINib(nibName: "SearchTableViewCell", bundle: .main), forCellReuseIdentifier: "searchCell")
	}
	
	static func build() -> CharactersSearchTableViewController {
		CharactersSearchTableViewController(nibName: "CharactersSearchTableViewController", bundle: .main)
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.characters.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
		
		let character = self.dataSource.characters[indexPath.row]
		cell.characterNameLabel.text = character.name
		
		if character.description.isEmpty {
			cell.characterDescriptionLabel.text = nil
			cell.characterDescriptionLabel.isHidden = true
		} else {
			cell.characterDescriptionLabel.isHidden = false
			cell.characterDescriptionLabel.text = String(character.description.prefix(100))
		}
		
		if let thumbnail = self.dataSource.thumbnail(forImagePath: character.thumbnail) {
			cell.characterThumbnailImageView.image = thumbnail
		} else {
			cell.characterThumbnailImageView.image = Asset.smallPlaceholderImage
			self.dataSource.downloadThumbnail(character.thumbnail, forIndexPath: indexPath)
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let character = self.dataSource.characters[indexPath.row]
		let characterDetailVC = CharacterDetailViewController.build(withCharacter: character)
		self.presentingViewController?.navigationController?.pushViewController(characterDetailVC, animated: true)
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// reached bottom
		if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
			self.dataSource.loadMoreData()
		}
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

