//
//  URLSessionHTTPClient.swift
//  Feed
//
//  Created by hamedpouramiri on 8/8/23.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
   private let session: URLSession

    public init(session: URLSession) {
        self.session = session
    }

    struct unexpectedValueRepresentation: Error {}
    
    public func get(from url: URL, field: [String: String]?, completion: @escaping (HTTPClient.Result)-> Void) -> HTTPClientTask? {
        let task = URLSessionHTTPClientTask(completion)
        var request = URLRequest(url: url)
        request.setHeaderField(field)
        request.httpMethod = "GET"
        task.wrapped = session.dataTask(with: request) { data, response, error in
            if let error = error {
                task.complete(with: .failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                task.complete(with: .success((data, response)))
            } else {
                task.complete(with: .failure(unexpectedValueRepresentation()))
            }
        }
        task.wrapped?.resume()
        return task
    }

    public func post(_ data: Data, to url: URL, field: [String: String]?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask? {
        let task = URLSessionHTTPClientTask(completion)
        var request = URLRequest(url: url)
        request.setHeaderField(field)
        request.httpMethod = "POST"
        request.httpBody = data
        task.wrapped = session.dataTask(with: request) { data, response, error in
            if let error = error {
                task.complete(with: .failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                task.complete(with: .success((data, response)))
            } else {
                task.complete(with: .failure(unexpectedValueRepresentation()))
            }
        }
        task.wrapped?.resume()
        return task
    }

    private final class URLSessionHTTPClientTask: HTTPClientTask {

        private var completion: ((HTTPClient.Result)-> Void)?
        var wrapped: URLSessionDataTask?
        
        init(_ completion: @escaping (HTTPClient.Result)-> Void) {
            self.completion = completion
        }
        
        func complete(with result: HTTPClient.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
}

