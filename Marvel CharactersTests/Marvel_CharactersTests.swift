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
			case .finished:
				print("testCharactersEndpointRepository - no issues")
			}
			testCharactersEndpointExpectation.fulfill()
		}, receiveValue: { (value) in
			print(value)
		}))
		self.wait(for: [testCharactersEndpointExpectation], timeout: 60)
	}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
