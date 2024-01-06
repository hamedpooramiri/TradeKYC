//
//  GetTokenUseCaseTests.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import XCTest
import APIModule
import MarzbanAPIModule

final class GetTokenUseCaseTests: XCTestCase {

    let url = URL(string: "https://sub.pablosoft.com/api")!

    func test_init_notNilURL() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getToken(username: "anyUsername", password: "") { _ in }
        XCTAssertTrue(!client.requestedURLs.isEmpty)
    }
    
    func test_getToken_callOnce() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getToken(username: "anyUsername", password: "") { _ in }
        XCTAssertTrue(client.requestedURLs.count == 1)
        XCTAssertEqual(client.requestedURLs.first?.request.url, url.appending(path: "/admin/token"))
    }
    
    func test_getToken_callTwice() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getToken(username: "anyUsername", password: "") { _ in }
        sut.getToken(username: "anyUsername", password: "") { _ in }
        XCTAssertTrue(client.requestedURLs.count == 2)
    }

    func test_getToken_deliversResponseOn200HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let token = anyToken()
        expGetToken(on: sut, toCompleteWith: .success(token.token)) {
            client.complete(withStatusCode: 200, with: token.data)
        }
    }

    func test_getToken_deliversErrorValidationOn422HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        expGetToken(on: sut, toCompleteWith: .failure(MarzbanService.Error.validation)) {
            client.complete(withStatusCode: 422, with: anyToken().data)
        }
    }

    func test_getToken_deliversErrorOnNon200HTTPResponse() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)

        let statusCodes = [190, 199, 201, 300, 400, 500].enumerated()
        
        statusCodes.forEach { index, code in
            expGetToken(on: sut, toCompleteWith: .failure(MarzbanService.Error.invalidData)) {
                client.complete(withStatusCode: code, at: index, with: anyToken().data)
            }
        }
    }

    func test_getToken_notDeliverResultAfterSUTDeallocated() {
        let client = HTTPClientSpy()
        var sut: MarzbanService? = makeSUT(client: client)
        
        var capturedResults = [MarzbanService.GetTokenResult]()
        sut?.getToken(username: "any username", password: "any password") { capturedResults.append($0) }
        sut = nil
        client.complete(withStatusCode: 200, with: Data())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }

    func test_getToken_deliverConnectivityErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        expGetToken(on: sut, toCompleteWith: .failure(MarzbanService.Error.connectivity)) {
            client.complete(with: .connectivity, at: 0)
        }
    }

    //MARK: - Helper
    
    private func makeSUT(client: HTTPClient, file: StaticString = #filePath, line: UInt = #line) -> MarzbanService {
        let sut = MarzbanService(url: url, httpClient: client)
        trackForMemoryLeaks(sut)
        return sut
    }

    private func expGetToken(on sut: MarzbanService, toCompleteWith expectedResult: MarzbanService.GetTokenResult, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.getToken(username: "any username", password: "any password") { receivedResult in
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

    func anyToken() -> (token: String, data: Data) {
        let stringToken = "any token"
        let json = [
            "access_token": stringToken,
            "token_type": "bearer"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        return (stringToken, jsonData)
     }
}
