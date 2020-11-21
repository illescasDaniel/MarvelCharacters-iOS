//
//  CharacterTableViewCell.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 20/11/20.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
	
	@IBOutlet weak var characterNameLabel: UILabel!
	@IBOutlet weak var characterDescriptionLabel: UILabel!
	@IBOutlet weak var characterThumbnailImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		characterThumbnailImageView.layer.cornerRadius = 8
		characterThumbnailImageView.layer.cornerCurve = .continuous
	}
}
