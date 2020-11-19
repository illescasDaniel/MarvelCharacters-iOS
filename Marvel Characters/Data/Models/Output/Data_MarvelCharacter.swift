//
//  MarvelCharacter.swift
//  Marvel Characters
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import Foundation

extension MarvelDataModel {
	struct MarvelCharacter: Decodable {
		/// The unique ID of the character resource.
		let id: Int
		/// The name of the character.
		let name: String
		/// A short bio or description of the character.
		let description: String
		/// The date the resource was most recently modified.
		let modified: Date
		/// The canonical URL identifier for this resource.
		let resourceURI: String
		/// A set of public web site URLs for the resource.
		let urls: [MarvelURL]
		/// The representative image for this character.
		let thumbnail: MarvelImage
		/// A resource list containing comics which feature this character.
		let comics: ComicList
		/// A resource list of stories in which this character appears.
		let stories: StoryList
		/// A resource list of events in which this character appears.
		let events: EventList
		/// A resource list of series in which this character appears.
		let series: SeriesList
	}
}
