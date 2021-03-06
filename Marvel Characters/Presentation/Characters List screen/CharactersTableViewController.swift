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
		
		self.dataSource.delegate = self
		
		self.title = NSLocalizedString("Marvel Characters", comment: "App title, used in main screen as its title")
		self.navigationItem.prompt = Other.attributionText
		self.navigationItem.largeTitleDisplayMode = .always
		self.navigationController?.navigationBar.prefersLargeTitles = true
		
		self.tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: .main), forCellReuseIdentifier: "characterCell")
		
		self.dataSource.loadData()
		
		let searchController = CharactersSearchTableViewController.build()
		
		self.navigationItem.searchController = UISearchController(searchResultsController: searchController)
		self.navigationItem.searchController?.searchResultsUpdater = searchController
		self.navigationItem.searchController?.definesPresentationContext = true
	}
	
	// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return self.dataSource.characterSections.count
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.characterSections[section].characters.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as! CharacterTableViewCell

		let character = self.dataSource.characterSections[indexPath.section].characters[indexPath.row]
		
		cell.characterNameLabel.text = character.name
		
		if character.description.isEmpty {
			cell.characterDescriptionLabel.text = nil
			cell.characterDescriptionLabel.isHidden = true
		} else {
			cell.characterDescriptionLabel.isHidden = false
			cell.characterDescriptionLabel.text = self.view.frame.width > 1200 ? String(character.description.prefix(500)) : String(character.description.prefix(300))
		}
		
		if let thumbnail = self.dataSource.imageThumbnail(forImagePath: character.thumbnail) {
			cell.characterThumbnailImageView.image = thumbnail
		} else {
			cell.characterThumbnailImageView.image = Asset.placeholderImage
			self.dataSource.downloadThumbnail(character.thumbnail, forIndexPath: indexPath)
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let character = self.dataSource.characterSections[indexPath.section].characters[indexPath.row]
		let cellImage = self.dataSource.imageThumbnail(forImagePath: character.thumbnail) ??
						Asset.bigPlaceholderImage
		self.performSegue(withIdentifier: Constants.SegueID.characterDetail.rawValue, sender: CharacterAndUIImageForSegue(character: character, image: cellImage))
	}
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let charactersSection = self.dataSource.characterSections[section]
		if charactersSection.characters.isEmpty {
			return nil
		}
		return String(describing: charactersSection.initial)
	}
	
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// reached bottom
		if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
			self.dataSource.loadData()
		}
	}
	
	// MARK: - Navigation
	
	@IBSegueAction func showCharacterDetail(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> CharacterDetailTableViewController? {
		let characterAndImage = sender as! CharacterAndUIImageForSegue
		return CharacterDetailTableViewController(coder: coder, character: characterAndImage.character, placeholderImage: characterAndImage.image)
	}
	
	// MARK: Actions
	
	@IBAction func changeCharactersOrderAction(_ sender: UIBarButtonItem) {
		self.dataSource.changeOrder()
	}
}
