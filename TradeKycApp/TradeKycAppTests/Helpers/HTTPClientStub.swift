//
//  HTTPClientStub.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/8/24.
//

import APIModule

final class HTTPClientStub: HTTPClient {

    private var stubs: [((URL) -> HTTPClient.Result)] = []

    init() {}
    
    func get(from url: URL, field: [String : String]?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask? {
        completion(stubs.last!(url))
        return nil
    }

    func post(_ data: Data, to url: URL, field: [String : String]?, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask? {
        completion(stubs.last!(url))
        return nil
    }

    func stub(completions: [(URL) -> HTTPClient.Result]) {
        stubs = completions
    }

}
