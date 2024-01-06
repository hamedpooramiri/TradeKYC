//
//  HTTPClientSpy.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation
import APIModule

final class HTTPClientSpy: HTTPClient {

    enum Request {
        case get(url: URL)
        case post(data: Data, url: URL)
        
        var url: URL {
            switch self {
            case let .get(url): url
            case let .post(_, url): url
            }
        }
    }
    
    var requestedURLs = [(request: Request, completion: (HTTPClient.Result) -> Void)]()

     @discardableResult
     func get(from url: URL, field: [String : String]?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask? {
         requestedURLs.append((.get(url: url), completion))
         return nil
     }

    @discardableResult
    func post(_ data: Data, to url: URL, field: [String : String]?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask? {
        requestedURLs.append((.post(data: data, url: url), completion))
        return nil
    }
    
     func complete(with error: Error, at index: Int) {
         requestedURLs[index].completion(.failure(error))
     }
     
     func complete(withStatusCode code: Int, at index: Int = 0, with data: Data) {
         let response = HTTPURLResponse(url: requestedURLs[index].request.url,
                                        statusCode: code,
                                        httpVersion: nil,
                                        headerFields: nil)!
         requestedURLs[index].completion(.success((data, response)))
     }
     
 }
