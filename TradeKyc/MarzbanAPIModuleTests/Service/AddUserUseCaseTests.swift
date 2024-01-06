//
//  AddUserUseCaseTests.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/1/24.
//

import XCTest
import APIModule
import MarzbanAPIModule

final class AddUserUseCaseTests: XCTestCase {

    let url = URL(string: "https://sub.pablosoft.com/api")!

    func test_init_notNilURL() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.addUser(username: "anyUsername", accessToken: "") { _ in }
        XCTAssertTrue(!client.requestedURLs.isEmpty)
    }
    
    func test_getUser_callOnce() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.addUser(username: "anyUsername", accessToken: "") { _ in }
        XCTAssertTrue(client.requestedURLs.count == 1)
        XCTAssertEqual(client.requestedURLs.first?.request.url, url.appending(path: "/user"))
    }
    
    func test_getUser_callTwice() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.addUser(username: "anyUsername", accessToken: "") { _ in }
        sut.addUser(username: "anyUsername", accessToken: "") { _ in }
        XCTAssertTrue(client.requestedURLs.count == 2)
    }
    
    func test_addUser_deliversResponseOn200HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expAddUser(on: sut, toCompleteWith: .success(userResponse.model)) {
            client.complete(withStatusCode: 200, with: userResponse.jsonData)
        }
    }

    func test_getUser_deliverConnectivityErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        expAddUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.connectivity)) {
            client.complete(with: .connectivity, at: 0)
        }
    }

    func test_addUser_deliversErrorUserAlreadyExistsOn409HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expAddUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.userAlreadyExists)) {
            client.complete(withStatusCode: 409, with: userResponse.jsonData)
        }
    }

    func test_addUser_deliversErrorValidationOn422HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expAddUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.validation)) {
            client.complete(withStatusCode: 422, with: userResponse.jsonData)
        }
    }

    func test_getToken_deliversErrorOnNon200HTTPResponse() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)

        let statusCodes = [190, 199, 201, 300, 400, 500].enumerated()
        
        statusCodes.forEach { index, code in
            expAddUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.invalidData)) {
                client.complete(withStatusCode: code, at: index, with: makeAnyUserResponse().jsonData)
            }
        }
    }

    func test_addUser_notDeliverResultAfterSUTDeallocated() {
        let client = HTTPClientSpy()
        var sut: MarzbanService? = makeSUT(client: client)
        
        var capturedResults = [MarzbanService.AddUserResult]()
        sut?.addUser(username: "any userName", accessToken: "any token") { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, with: Data())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }



    //MARK: - Helper
    
    private func makeSUT(client: HTTPClient, file: StaticString = #filePath, line: UInt = #line) -> MarzbanService {
        let sut = MarzbanService(url: url, httpClient: client)
        trackForMemoryLeaks(sut)
        return sut
    }
    
    func expAddUser(on sut: MarzbanService, toCompleteWith expectedResult: MarzbanService.AddUserResult, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.addUser(username: "any userName", accessToken: "any token") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as MarzbanService.Error), .failure(expectedError as MarzbanService.Error)):
                XCTAssertEqual(receivedError , expectedError , file: file, line: line)
            default:
                XCTFail("expected to get result \(expectedResult) but got \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp])
    }

}
