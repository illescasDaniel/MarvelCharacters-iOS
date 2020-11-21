//
//  CharacterDetailViewController.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 21/11/20.
//

import UIKit

class CharacterDetailViewController: UIViewController {
	
	private var character: MarvelCharacter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.prompt = Other.attributionText
	}
	
	static func build(withCharacter character: MarvelCharacter) -> CharacterDetailViewController {
		let storyboard = UIStoryboard(name: "Main", bundle: .main)
		let vc = storyboard.instantiateViewController(identifier: Constants.StoryboardViewControllerID.characterDetail.rawValue) as! CharacterDetailViewController
		vc.setup(withCharacter: character)
		return vc
	}
	
	func setup(withCharacter character: MarvelCharacter) {
		self.character = character
		self.title = self.character.name
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
