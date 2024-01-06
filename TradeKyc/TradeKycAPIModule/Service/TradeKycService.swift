//
//  TradeKycService.swift
//  TradeKycAPIModule
//
//  Created by hamedpouramiri on 1/3/24.
//

import Foundation
import TradeKyc
import APIModule

public final class TradeKycService: TradeKycServiceProtocol {

    public enum Error: Swift.Error {
        case invalidData
        case connectivity
    }

    private var httpClient: HTTPClient
    private var url: URL

    public init(url: URL, httpClient: HTTPClient) {
        self.url = url
        self.httpClient = httpClient
    }

    public func getAdmin(completion: @escaping (GetAdminResult) -> Void) {
        _ = httpClient.get(from: url, field: [:]) { [weak self] result in
            guard self != nil else { return }
            if case let .success((data, response)) = result {
                if response.isOK, let admin = try? GetAdminMapper.map(data: data) {
                    completion(.success(admin))
                } else {
                    completion(.failure(Error.invalidData))
                }
            } else {
                completion(.failure(Error.connectivity))
            }
        }
    }
}
