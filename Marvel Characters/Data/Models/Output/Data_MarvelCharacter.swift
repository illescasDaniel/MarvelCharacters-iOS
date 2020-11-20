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
		
		enum CodingKeys: String, CodingKey {
			case id, name, description, modified, resourceURI, urls, thumbnail, comics, stories, events, series
		}
		
		init(from decoder: Decoder) throws {
			let container = try decoder.container(keyedBy: CodingKeys.self)
			
			let id = try container.decode(Int.self, forKey: .id)
			
			if Constants.useAgressiveCaching, let cachedCharacter = MarvelCharacterDecodingCache.shared.value(forID: id) {
				print("Reconstructing character from cached value")
				self = cachedCharacter
				return
			}
			
			self.id = id
			self.name = try container.decode(String.self, forKey: .name)
			self.description = try container.decode(String.self, forKey: .description)
			self.modified = try container.decode(Date.self, forKey: .modified)
			self.resourceURI = try container.decode(String.self, forKey: .resourceURI)
			self.urls = try container.decode([MarvelURL].self, forKey: .urls)
			self.thumbnail = try container.decode(MarvelImage.self, forKey: .thumbnail)
			self.comics = try container.decode(ComicList.self, forKey: .comics)
			self.stories = try container.decode(StoryList.self, forKey: .stories)
			self.events = try container.decode(EventList.self, forKey: .events)
			self.series = try container.decode(SeriesList.self, forKey: .series)
			
			MarvelCharacterDecodingCache.shared.storeValue(self, id: id)
		}
	}
}
