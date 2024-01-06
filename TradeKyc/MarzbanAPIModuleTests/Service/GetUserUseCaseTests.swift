//
//  GetUserUseCaseTests.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import XCTest
import APIModule
import MarzbanAPIModule

final class GetUserUseCaseTests: XCTestCase {

    let url = URL(string: "https://sub.pablosoft.com/api")!

    func test_init_notNilURL() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getUser(username: "anyUsername", accessToken: "") { _ in }
        XCTAssertTrue(!client.requestedURLs.isEmpty)
    }
    
    func test_getUser_callOnce() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getUser(username: "anyUsername", accessToken: "") { _ in }
        XCTAssertTrue(client.requestedURLs.count == 1)
        XCTAssertEqual(client.requestedURLs.first?.request.url, url.appending(path: "/user/anyUsername"))
    }
    
    func test_getUser_callTwice() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getUser(username: "anyUsername", accessToken: "") { _ in }
        sut.getUser(username: "anyUsername", accessToken: "") { _ in }
        XCTAssertTrue(client.requestedURLs.count == 2)
    }
    
    func test_getUser_deliversResponseOn200HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expGetUser(on: sut, toCompleteWith: .success(userResponse.model)) {
            client.complete(withStatusCode: 200, with: userResponse.jsonData)
        }
    }
  
    func test_getUser_deliversUnAuthorizedErrorOn403HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expGetUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.unAuthorized)) {
            client.complete(withStatusCode: 403, with: userResponse.jsonData)
        }
    }

    func test_getUser_deliversNotFoundErrorOn404HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expGetUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.notFound)) {
            client.complete(withStatusCode: 404, with: userResponse.jsonData)
        }
    }

    func test_getUser_deliversValidationErrorOn422HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let userResponse = makeAnyUserResponse()
        expGetUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.validation)) {
            client.complete(withStatusCode: 422, with: userResponse.jsonData)
        }
    }

    func test_getUser_deliverConnectivityErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        expGetUser(on: sut, toCompleteWith: .failure(MarzbanService.Error.connectivity)) {
            client.complete(with: .connectivity, at: 0)
        }
    }

    func test_getUser_notDeliverResultAfterSUTDeallocated() {
        let client = HTTPClientSpy()
        var sut: MarzbanService? = makeSUT(client: client)
        
        var capturedResults = [MarzbanService.GetUserResult]()
        sut?.getUser(username: "any userName", accessToken: "any token") { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, with: Data())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }

//    //MARK: - Helper
    
    private func makeSUT(client: HTTPClient, file: StaticString = #filePath, line: UInt = #line) -> MarzbanService {
        let sut = MarzbanService(url: url, httpClient: client)
        trackForMemoryLeaks(sut)
        return sut
    }

    private func expGetUser(on sut: MarzbanService, toCompleteWith expectedResult: MarzbanService.GetUserResult, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.getUser(username: "any userName", accessToken: "any token") { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as MarzbanService.Error), .failure(expectedError as MarzbanService.Error)):
                XCTAssertEqual(receivedError , expectedError , file: file, line: line)
                break
            default:
                XCTFail("expected to get result \(expectedResult) but got \(receivedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp])
    }

}
