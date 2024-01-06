//
//  HttpClient.swift
//  Feed
//
//  Created by hamedpouramiri on 8/7/23.
//

import Foundation

public protocol HTTPClientTask {
    typealias Result = HTTPClient.Result
    init(_ completion: @escaping (Result)-> Void)
    func complete(with result: Result)
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    func get(from url: URL, field: [String: String]?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
    func post(_ data: Data, to url: URL, field: [String: String]?, completion: @escaping (Result) -> Void) -> HTTPClientTask?
}
