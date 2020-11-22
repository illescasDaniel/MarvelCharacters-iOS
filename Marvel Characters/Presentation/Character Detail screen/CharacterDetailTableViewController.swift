//
//  CharacterDetailTableViewController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import UIKit

class CharacterDetailTableViewController: UITableViewController {
	
	@IBOutlet weak var characterImageView: UIImageView!
	@IBOutlet private weak var bigCharacterNameLabel: UILabel!
	@IBOutlet private weak var characterNameLabel: UILabel!
	@IBOutlet private weak var characterDescriptionLabel: UILabel!
	@IBOutlet private weak var characterLinksTextView: UITextView!
	
	private let character: MarvelCharacter
	private let placeholderImage: UIImage
	
	let dataSource = CharacterDetailDataSource()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false
		
		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		dataSource.delegate = self
		dataSource.downloadCharacterImage(fromPath: self.character.thumbnail)
		setupNavigationBar()
		setupViews()
		setupCharacterViews()
	}
	
	init?(coder: NSCoder, character: MarvelCharacter, placeholderImage: UIImage) {
		self.character = character
		self.placeholderImage = placeholderImage
		
		super.init(coder: coder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented. You need to use init?(coder: NSCoder, character: MarvelCharacter, placeholderImage: UIImage)")
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section == 2 /* links */ else { return }
		let urls = character.urls.compactMap(URL.init)
		UIApplication.shared.open(urls[indexPath.row], options: [:], completionHandler: nil)
	}
	
	// MARK: Convenience
	
	private func setupNavigationBar() {
		self.title = nil
		self.navigationItem.prompt = Other.attributionText
	}
	
	private func setupViews() {
		self.tableView.allowsSelection = false
		self.characterImageView.image = self.placeholderImage
		self.characterImageView.layer.cornerRadius = 8
		self.characterImageView.layer.cornerCurve = .continuous
	}
	
	private func setupCharacterViews() {
		let firstNameWords = character.name.split(separator: " ").prefix(2)
		if firstNameWords.contains(where: { $0.contains("(") }) {
			self.bigCharacterNameLabel.text = String(firstNameWords[0])
		} else if firstNameWords.contains(where: { $0.contains("of") }) {
			self.bigCharacterNameLabel.text = character.name.split(separator: " ").prefix(3).joined(separator: " ")
		} else {
			self.bigCharacterNameLabel.text = firstNameWords.joined(separator: " ")
		}
		self.characterNameLabel.text = character.name
		self.characterDescriptionLabel.text = character.description.isEmpty
			? NSLocalizedString("(empty)", comment: "Empty content") 
			: character.description
		
		let linksAttributedString = NSMutableAttributedString()
		let urls = character.urls.compactMap(URL.init)
		for (index, url) in urls.enumerated() {
			var urlTextToDisplay: String
			if let scheme = url.scheme, !scheme.isEmpty, url.absoluteString.count > scheme.count + 3 {
				urlTextToDisplay = (url.absoluteString.dropFirst(scheme.count + "://".count).prefix(40) + "...")
			} else {
				urlTextToDisplay = (url.absoluteString.prefix(40) + "...")
			}
			if index < (urls.count - 1) {
				urlTextToDisplay += "\n\n"
			}
			let attributedURL = NSAttributedString(
				string: urlTextToDisplay,
				attributes: [
					.link : url,
					.font: UIFont.preferredFont(forTextStyle: .callout)
				]
			)
			linksAttributedString.append(attributedURL)
		}
		self.characterLinksTextView.attributedText = linksAttributedString
	}
}
