//
//  CharacterDetailTableViewController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import UIKit

class CharacterDetailTableViewController: UITableViewController {
	
	@IBOutlet private weak var bigCharacterNameLabel: UILabel!
	@IBOutlet private weak var characterNameLabel: UILabel!
	@IBOutlet private weak var characterDescriptionLabel: UILabel!
	@IBOutlet private weak var characterLinksTextView: UITextView!
	
	private var character: MarvelCharacter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		setupNavigationBar()
		setupCharacterViews()
	}
	
	static func build(withCharacter character: MarvelCharacter) -> CharacterDetailTableViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: .main)
		let vc = storyboard.instantiateViewController(identifier: Constants.StoryboardViewControllerID.characterDetail.rawValue) as! CharacterDetailTableViewController
		vc.setup(withCharacter: character)
		return vc
	}
	
	func setup(withCharacter character: MarvelCharacter) {
		self.character = character
	}
	
	// MARK: Convenience
	
	private func setupNavigationBar() {
		self.title = nil
		self.navigationItem.prompt = Other.attributionText
		
		self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.layoutIfNeeded()
	}
	
	private func setupCharacterViews() {
		let firstNameWords = character.name.split(separator: " ").prefix(2)
		if firstNameWords.contains(where: { $0.contains("(") }) {
			self.bigCharacterNameLabel.text = String(firstNameWords[0])
		} else {
			self.bigCharacterNameLabel.text = firstNameWords.joined(separator: " ")
		}
		self.characterNameLabel.text = character.name
		self.characterDescriptionLabel.text = character.description.isEmpty ? "(empty)" : character.description
		self.characterLinksTextView.text = character.urls.joined(separator: "\n\n")
		
		
	}
}
