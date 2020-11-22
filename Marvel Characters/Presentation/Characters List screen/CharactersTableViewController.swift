//
//  CharactersTableViewController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

class CharactersTableViewController: UITableViewController {
	
	lazy var dataSource: CharactersListDiffableDataSource = .init(
		charactersRepository: MarvelCharactersRepositoryImplementation(),
		tableView: self.tableView,
		cellProvider: self.cellForRow
	)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		setupNavigationItem()
		self.tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: .main), forCellReuseIdentifier: "characterCell")
		self.dataSource.delegate = self
		self.dataSource.loadData()
	}
	
	private func setupNavigationItem() {
		
		self.title = NSLocalizedString("Marvel Characters", comment: "App title, used in main screen as its title")
		self.navigationItem.prompt = Other.attributionText
		self.navigationItem.largeTitleDisplayMode = .always
		self.navigationController?.navigationBar.prefersLargeTitles = true
		
		let searchController = CharactersSearchTableViewController.build()
		self.navigationItem.searchController = UISearchController(searchResultsController: searchController)
		self.navigationItem.searchController?.searchResultsUpdater = searchController
		self.navigationItem.searchController?.definesPresentationContext = true
	}
	
	// MARK: - Table view data source setup
	
	private func cellForRow(in tableView: UITableView, atIndexPath indexPath: IndexPath, with character: MarvelCharacter) -> CharacterTableViewCell? {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell else { return nil }

		cell.characterNameLabel.text = character.name

		if character.description.isEmpty {
			cell.characterDescriptionLabel.text = nil
			cell.characterDescriptionLabel.isHidden = true
		} else {
			let descriptionLimit = 300
			cell.characterDescriptionLabel.isHidden = false
			cell.characterDescriptionLabel.text = character.description.count > descriptionLimit ? String(character.description.prefix(300))+"..." : character.description
		}

		if let thumbnail = self.dataSource.thumbnail(forCharacter: character) {
			cell.characterThumbnailImageView.image = thumbnail
		} else {
			cell.characterThumbnailImageView.image = Asset.placeholderImage
			self.dataSource.downloadThumbnail(forCharacter: character)
		}

		return cell
	}
	
	// MARK: - Table view delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let character = self.dataSource.itemIdentifier(for: indexPath)!
		let cellImage = self.dataSource.thumbnail(forCharacter: character) ??
						Asset.bigPlaceholderImage
		self.performSegue(withIdentifier: Constants.SegueID.characterDetail.rawValue, sender: CharacterAndUIImageForSegue(character: character, image: cellImage))
	}

	// MARK: Scrollview delegate
	
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
