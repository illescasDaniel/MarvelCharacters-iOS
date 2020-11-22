//
//  Marvel_CharactersTests.swift
//  Marvel CharactersTests
//
//  Created by Daniel Illescas Romero on 18/11/20.
//

import XCTest
import Combine
@testable import Marvel_Characters

class Marvel_CharactersTests: XCTestCase {
	
	let dataSource = MarvelCharactersDataSource()
	let repository: MarvelCharactersRepository = MarvelCharactersRepositoryImplementation()
	var cancellables: [AnyCancellable] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

	func testCharacterByIDEndpoint() {
		let testCharacterByIDEndpointExpectation = expectation(description: "testCharacterByIDEndpoint")
		self.cancellables.append(self.dataSource.character(id: 1010338).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
			case .finished:
				print("testCharacterByIDEndpoint - no issues")
			}
			testCharacterByIDEndpointExpectation.fulfill()
		}, receiveValue: { (value) in
			print(value)
		}))
		self.wait(for: [testCharacterByIDEndpointExpectation], timeout: 60)
	}
	
	func testCharactersEndpoint() {
		let testCharactersEndpointExpectation = expectation(description: "testCharactersEndpoint")
		let parameters = MarvelCharacterParametersBuilder()
			//.nameStartsWith(prefix: "Spider")
			//.page(0, limit: 7)
			.build()
		
		self.cancellables.append(self.dataSource.characters(parameters: parameters).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
			case .finished:
				print("testCharactersEndpoint - no issues")
			}
			testCharactersEndpointExpectation.fulfill()
		}, receiveValue: { (value) in
			print(value)
		}))
		self.wait(for: [testCharactersEndpointExpectation], timeout: 60)
	}
	
	//
	
	func testCharacterByIDEndpointRepository() {
		let testCharacterByIDEndpointExpectation = expectation(description: "testCharacterByIDEndpointRepository")
		self.cancellables.append(self.repository.character(id: 1010338).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
			case .finished:
				print("testCharacterByIDEndpointRepository - no issues")
			}
			testCharacterByIDEndpointExpectation.fulfill()
		}, receiveValue: { (value) in
			print(value)
		}))
		self.wait(for: [testCharacterByIDEndpointExpectation], timeout: 60)
	}
	
	func testCharactersEndpointRepository() {
		let testCharactersEndpointExpectation = expectation(description: "testCharactersEndpointRepository")
		let parameters = MarvelCharacterParametersBuilder()
			//.nameStartsWith(prefix: "Spider")
			//.page(0, limit: 7)
			.build()

		self.cancellables.append(self.repository.characters(parameters: parameters).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
			case .finished:
				print("testCharactersEndpointRepository - no issues")
			}
			testCharactersEndpointExpectation.fulfill()
		}, receiveValue: { (value) in
			print(value)
		}))
		self.wait(for: [testCharactersEndpointExpectation], timeout: 60)
	}
	
	func testMappingFromCharacterWrapperToCharacter() {
		let testCharacterMappingExpectation = expectation(description: "testCharacterMappingExpectation")
		self.cancellables.append(self.dataSource.character(id: 1010338).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
				testCharacterMappingExpectation.fulfill()
			case .finished:
				break
			}
		}, receiveValue: { (characterWrapper) in
			print(characterWrapper)
			let mappedCharacter = MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacter(characterWrapper)
			XCTAssertEqual(characterWrapper.data.results.count, 1)
			XCTAssertNotNil(characterWrapper.data.results.first)
			let originalCharacter = characterWrapper.data.results.first!
			
			XCTAssertEqual(originalCharacter.id, mappedCharacter.id)
			XCTAssertEqual(originalCharacter.name.trimmingCharacters(in: .whitespacesAndNewlines), mappedCharacter.name)
			XCTAssertEqual(originalCharacter.description.trimmingCharacters(in: .whitespacesAndNewlines), mappedCharacter.description)
			XCTAssertEqual(originalCharacter.urls.compactMap {
				let url = $0.url.trimmingCharacters(in: .whitespacesAndNewlines)
				return url.isEmpty ? nil : url
			}, mappedCharacter.urls)
			XCTAssertEqual(originalCharacter.thumbnail.path, mappedCharacter.thumbnail.path)
			XCTAssertEqual(originalCharacter.thumbnail.imageExtension, mappedCharacter.thumbnail.imageExtension)
			
			testCharacterMappingExpectation.fulfill()
		}))
		self.wait(for: [testCharacterMappingExpectation], timeout: 60)
	}
	
	func testCharactersMapping() {
		let testCharactersEndpointExpectation = expectation(description: "testCharactersEndpoint")
		let parameters = MarvelCharacterParametersBuilder()
			//.nameStartsWith(prefix: "Spider")
			//.page(0, limit: 7)
			.build()
		
		self.cancellables.append(self.dataSource.characters(parameters: parameters).receive(on: DispatchQueue.main).sink(receiveCompletion: { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
				testCharactersEndpointExpectation.fulfill()
			case .finished:
				print("testCharactersEndpoint - no issues")
			}
		}, receiveValue: { (characterDataWrapper) in
			let originalCharacters = characterDataWrapper.data.results
			let mappedCharacters = MarvelCharacterModelMapper.mapCharacterDataWrapperToCharacters(characterDataWrapper)
			
			XCTAssertEqual(originalCharacters.count, mappedCharacters.count)
			
			for (originalCharacter, mappedCharacter) in
				zip(originalCharacters.sorted(by: { $0.id < $1.id }), mappedCharacters.sorted(by: { $0.id < $1.id })) {
				
				XCTAssertEqual(originalCharacter.id, mappedCharacter.id)
				XCTAssertEqual(originalCharacter.name.trimmingCharacters(in: .whitespacesAndNewlines), mappedCharacter.name)
				XCTAssertEqual(originalCharacter.description.trimmingCharacters(in: .whitespacesAndNewlines), mappedCharacter.description)
				XCTAssertEqual(originalCharacter.urls.compactMap {
					let url = $0.url.trimmingCharacters(in: .whitespacesAndNewlines)
					return url.isEmpty ? nil : url
				}, mappedCharacter.urls)
				XCTAssertEqual(originalCharacter.thumbnail.path, mappedCharacter.thumbnail.path)
				XCTAssertEqual(originalCharacter.thumbnail.imageExtension, mappedCharacter.thumbnail.imageExtension)
			}
			
			testCharactersEndpointExpectation.fulfill()
		}))
		self.wait(for: [testCharactersEndpointExpectation], timeout: 60)
	}
	
	func testDownloadCharacterThumbnail() {
	//func downloadCharacterThumbnail(_ thumbnailURL: String) -> AnyPublisher<Data, URLError>
	}
	
	func testCharactersSortedByNamePaginated() {
		
		let testCharactersSortedByNamePaginatedExpectation = expectation(description: "testCharactersSortedByNamePaginated")
		Publishers.MergeMany(
			repository.charactersSortedByNamePaginated(limit: 20, page: 0, ascending: true),
			repository.charactersSortedByNamePaginated(limit: 20, page: 1, ascending: true),
			repository.charactersSortedByNamePaginated(limit: 20, page: 2, ascending: true)
		)
		.collect()
		.map { (output) in
			output.flatMap { $0 }
		}
		.sink { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
				testCharactersSortedByNamePaginatedExpectation.fulfill()
			case .finished:
				print("testCharactersSortedByNamePaginated - no issues")
			}
		} receiveValue: { (characters) in
			print(characters.count)
			XCTAssertEqual(characters.count, 60)
			XCTAssertEqual(Set(characters).count, characters.count)
			testCharactersSortedByNamePaginatedExpectation.fulfill()
		}
		.store(in: &cancellables)
		
		self.wait(for: [testCharactersSortedByNamePaginatedExpectation], timeout: 60)
	}
	
	func testSearchCharacters() {
		let testSearchCharactersExpectation = expectation(description: "testSearchCharacters")
		
		let namePrefix = "Spi"
		let searchResultsLimit = 10
		
		let request = repository.searchCharactersPaginated(startingWith: namePrefix, limit: searchResultsLimit, page: 0)
		request.sink { (completion) in
			switch completion {
			case .failure(let error):
				dump(error)
				XCTFail(error.localizedDescription)
			case .finished:
				print("testCharactersSortedByNamePaginated - no issues")
			}
			testSearchCharactersExpectation.fulfill()
		} receiveValue: { (characters) in
			XCTAssertLessThanOrEqual(characters.count, searchResultsLimit)
			for character in characters {
				XCTAssertTrue(character.name.uppercased().starts(with: namePrefix.uppercased()))
			}
		}
		.store(in: &cancellables)

		self.wait(for: [testSearchCharactersExpectation], timeout: 60)
	}
}
