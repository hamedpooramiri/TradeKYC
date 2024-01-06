//
//  GetAminUseCaseTests.swift
//  TradeKycAPIModuleTests
//
//  Created by hamedpouramiri on 1/3/24.
//

import XCTest
import APIModule
import TradeKycAPIModule

final class GetAminUseCaseTests: XCTestCase {

    let url = URL(string: "any-url")!

    func test_init_notNilURL() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getAdmin() { _ in }
        XCTAssertTrue(!client.requestedURLs.isEmpty)
    }
    
    func test_getAdmin_callOnce() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getAdmin() { _ in }
        XCTAssertTrue(client.requestedURLs.count == 1)
        XCTAssertEqual(client.requestedURLs.first?.request.url, url)
    }
    
    func test_getAdmin_callTwice() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        sut.getAdmin() { _ in }
        sut.getAdmin() { _ in }
        XCTAssertTrue(client.requestedURLs.count == 2)
    }
    
    func test_getAdmin_deliversResponseOn200HTTPResponse() throws {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        let adminResponse = makeAnyAdminResponse()
        expGetAdmin(on: sut, toCompleteWith: .success(adminResponse.model)) {
            client.complete(withStatusCode: 200, with: adminResponse.jsonData)
        }
    }

    func test_getAdmin_deliverConnectivityErrorOnClientError() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)
        expGetAdmin(on: sut, toCompleteWith: .failure(TradeKycService.Error.connectivity)) {
            client.complete(with: TradeKycService.Error.connectivity, at: 0)
        }
    }

    func test_getAdmin_deliversErrorOnNon200HTTPResponse() {
        let client = HTTPClientSpy()
        let sut = makeSUT(client: client)

        let statusCodes = [190, 199, 201, 300, 400, 401, 403, 422, 500].enumerated()
        
        statusCodes.forEach { index, code in
            expGetAdmin(on: sut, toCompleteWith: .failure(TradeKycService.Error.invalidData)) {
                client.complete(withStatusCode: code, at: index, with: makeAnyAdminResponse().jsonData)
            }
        }
    }

    func test_getAdmin_notDeliverResultAfterSUTDeallocated() {
        let client = HTTPClientSpy()
        var sut: TradeKycService? = makeSUT(client: client)
        
        var capturedResults = [TradeKycService.GetAdminResult]()
        sut?.getAdmin() { capturedResults.append($0) }
        
        sut = nil
        client.complete(withStatusCode: 200, with: Data())
        
        XCTAssertTrue(capturedResults.isEmpty)
    }

//    //MARK: - Helper
    
    private func makeSUT(client: HTTPClient, file: StaticString = #filePath, line: UInt = #line) -> TradeKycService {
        let sut = TradeKycService(url: url, httpClient: client)
        trackForMemoryLeaks(sut)
        return sut
    }

    private func expGetAdmin(on sut: TradeKycService, toCompleteWith expectedResult: TradeKycService.GetAdminResult, when action: ()-> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "wait for load completion")
        sut.getAdmin() { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError as TradeKycService.Error), .failure(expectedError as TradeKycService.Error)):
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
