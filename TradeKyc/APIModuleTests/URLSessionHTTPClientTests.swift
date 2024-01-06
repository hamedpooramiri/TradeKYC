//
//  URLSessionHTTPClientTests.swift
//  FeedTests
//
//  Created by hamedpouramiri on 8/8/23.
//

import XCTest
import Foundation
import APIModule

final class URLSessionHTTPClientTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performGetRequest() {
        let url = URL(string: "http://a-url.com")!
        let exp = expectation(description: "wait for observeRequests")
        let fields = ["any header": "any value"]
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.allHTTPHeaderFields, fields)
            exp.fulfill()
        }
        _ = makeSUT().get(from: url, field: fields) { _ in}
        wait(for: [exp])
    }
    
    func test_postToURL_performPOSTRequest() {
        let url = URL(string: "http://a-url.com")!
        let exp = expectation(description: "wait for observeRequests")
        let fields = ["any header": "any value"]
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(request.allHTTPHeaderFields, fields)
            exp.fulfill()
        }
        _ = makeSUT().post(anyData(), to: url, field: fields) { _ in }
        wait(for: [exp])
    }
    
    func test_getFromURL_failsOnRequestError() {
        let domainError = anyNSError()
        URLProtocolStub.stub(data: nil, response: nil, error: domainError)
        let expectedError = resultErrorFor(url: anyURL(), data: nil, response: nil, error: domainError)
        XCTAssertEqual(expectedError?.localizedDescription, domainError.localizedDescription)
    }
    
    func test_postToURL_failsOnRequestError() {
        let domainError = anyNSError()
        URLProtocolStub.stub(data: nil, response: nil, error: domainError)
        let expectedError = postResultErrorFor(url: anyURL(), data: nil, response: nil, error: domainError)
        XCTAssertEqual(expectedError?.localizedDescription, domainError.localizedDescription)
    }

    func test_getFromURL_failsOnInvalidRepresentableState() {
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: nil, response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: nil, response: anyURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: nil, response: anyURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: anyData(), response: anyURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(resultErrorFor(url: anyURL(), data: anyData(), response: anyURLResponse(), error: nil))
    }

    func test_postToURL_failsOnInvalidRepresentableState() {
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: nil, response: nil, error: nil))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: nil, response: anyURLResponse(), error: nil))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: anyData(), response: nil, error: nil))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: anyData(), response: nil, error: anyNSError()))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: nil, response: anyURLResponse(), error: anyNSError()))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: anyData(), response: anyURLResponse(), error: anyNSError()))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        XCTAssertNotNil(postResultErrorFor(url: anyURL(), data: anyData(), response: anyURLResponse(), error: nil))
    }

    func test_getFromURL_succeedsOnHttpURLResponseWithData() {
        let expectedData = anyData()
        let expectedResponse = anyHTTPURLResponse()
        let result = resultValuesFor(url: anyURL(), data: expectedData, response: expectedResponse, error: nil)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data, expectedData)
        XCTAssertEqual(result?.response.statusCode, expectedResponse.statusCode)
        XCTAssertEqual(result?.response.url, expectedResponse.url)
    }
    
    func test_postToURL_succeedsOnHttpURLResponseWithData() {
        let expectedData = anyData()
        let expectedResponse = anyHTTPURLResponse()
        let result = postResultValuesFor(url: anyURL(), data: expectedData, response: expectedResponse, error: nil)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data, expectedData)
        XCTAssertEqual(result?.response.statusCode, expectedResponse.statusCode)
        XCTAssertEqual(result?.response.url, expectedResponse.url)
    }

    func test_getFromURL_succeedsEmptyDataOnHttpURLResponseWithNilData() {
        let expectedResponse = anyHTTPURLResponse()
        let result = resultValuesFor(url: anyURL(), data: nil, response: expectedResponse, error: nil)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data, Data())
        XCTAssertEqual(result?.response.statusCode, expectedResponse.statusCode)
        XCTAssertEqual(result?.response.url, expectedResponse.url)
    }
    
    func test_postToURL_succeedsEmptyDataOnHttpURLResponseWithNilData() {
        let expectedResponse = anyHTTPURLResponse()
        let result = postResultValuesFor(url: anyURL(), data: nil, response: expectedResponse, error: nil)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.data, Data())
        XCTAssertEqual(result?.response.statusCode, expectedResponse.statusCode)
        XCTAssertEqual(result?.response.url, expectedResponse.url)
    }
    
    //MARK: - Helper
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> HTTPClient {
        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(URLProtocolStub.self, at: 0)
        let session = URLSession(configuration: config)
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut)
        return sut
    }

    func resultErrorFor(url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let result = getResultFor(url: url, data: data, response: response, error: error,file: file, line: line)
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("expected failure but got \(result)", file: file, line: line)
            return nil
        }
    }

    func resultValuesFor(url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = getResultFor(url: url, data: data, response: response, error: error, file: file, line: line)
        switch result {
        case let .success((data, response)):
            return (data, response)
        case .failure(let error):
            XCTFail("expected to be success but got failure with error \(error)", file: file, line: line)
            return nil
        }
    }
    
    
    private func getResultFor(url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let exp = expectation(description: "a wait")
        var capturedResult: HTTPClient.Result!
        _ = makeSUT(file: file, line: line).get(from: url, field: [:]) { result in
            capturedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        return capturedResult
    }
    
    
    func postResultErrorFor(url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> Error? {
        let result = postResultFor(url: url, data: data, response: response, error: error,file: file, line: line)
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("expected failure but got \(result)", file: file, line: line)
            return nil
        }
    }

    func postResultValuesFor(url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> (data: Data, response: HTTPURLResponse)? {
        let result = postResultFor(url: url, data: data, response: response, error: error, file: file, line: line)
        switch result {
        case let .success((data, response)):
            return (data, response)
        case .failure(let error):
            XCTFail("expected to be success but got failure with error \(error)", file: file, line: line)
            return nil
        }
    }

    private func postResultFor(url: URL, data: Data?, response: URLResponse?, error: Error?, file: StaticString = #filePath, line: UInt = #line) -> HTTPClient.Result {
        URLProtocolStub.stub(data: data, response: response, error: error)
        let exp = expectation(description: "a wait")
        var capturedResult: HTTPClient.Result!
        _ = makeSUT(file: file, line: line).post(anyData(), to: url, field: [:]) { result in
            capturedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        return capturedResult
    }

    func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }
    
    func anyURLResponse() -> URLResponse {
        URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }

    func anyData() -> Data {
        Data()
    }

    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }

    private class URLProtocolStub: URLProtocol {

        private static var stub: Stub?
        private static var observeRequest: ((URLRequest)-> Void)?

        public struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }
        
        static func stub(data: Data?, response: URLResponse?, error: Error?) {
            URLProtocolStub.stub = Stub(data: data, response: response, error: error)
        }
        
        static func startInterceptingRequests() {
            URLProtocol.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequests(){
            URLProtocol.unregisterClass(URLProtocolStub.self)
            stub = nil
            observeRequest = nil
        }
        
        static func observeRequests(_ observer: @escaping (URLRequest)-> Void) {
            observeRequest = observer
        }

        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let observe = URLProtocolStub.observeRequest {
                client?.urlProtocolDidFinishLoading(self)
                observe(request)
                URLProtocolStub.observeRequest = nil
                return
            }

            if let data = URLProtocolStub.stub?.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = URLProtocolStub.stub?.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let error = URLProtocolStub.stub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }

}
