//
//  MarzbanService.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/1/24.
//

import Foundation
import TradeKyc
import APIModule

public final class MarzbanService: MarzbanServiceProtocol {

    private var httpClient: HTTPClient
    private var url: URL

    public init(url: URL, httpClient: HTTPClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func getToken(username: String, password: String, completion: @escaping (GetTokenResult) -> Void) {
        guard let data = try? GetTokenMapper.encodeBodyRequest(username: username, password: password) else {
            return completion(.failure(Error.invalidData))
        }
        _ = httpClient.post(data, to: url.appending(path: "/admin/token"), field: ["Content-Type": "application/json"]) { [weak self] result in
            guard self != nil else { return }
            if case let .success((data, response)) = result {
                if response.isOK, let tokenResponse = try? GetTokenMapper.map(data: data), let token = tokenResponse.access_token {
                    return completion(.success(token))
                } else if response.isValidationError {
                    return completion(.failure(Error.validation))
                } else {
                    return completion(.failure(Error.invalidData))
                }
            } else {
                completion(.failure(Error.connectivity))
            }
        }
    }

    public func getUser(username: String, accessToken: String, completion: @escaping (GetUserResult) -> Void) {
        let field = generateHeaderFields(using: accessToken)
        _ = httpClient.get(from: url.appending(path: "/user/\(username)"), field: field) { [weak self] result in
            guard self != nil else { return }
            if case let .success((data, response)) = result {
                if response.isOK, let user = try? GetUserMapper.map(data: data) {
                    completion(.success(user))
                } else if response.isUnAuthorizedError {
                    completion(.failure(Error.unAuthorized))
                } else if response.isNotFoundError {
                    completion(.failure(Error.notFound))
                } else if response.isValidationError {
                    completion(.failure(Error.validation))
                } else {
                    completion(.failure(Error.connectivity))
                }
            } else {
                completion(.failure(Error.connectivity))
            }
        }
    }

    public func addUser(username: String, accessToken: String, completion: @escaping (AddUserResult) -> Void){
        guard let reqBody = try? AddUserMapper.encodeBodyRequest(username: username) else {
            return completion(.failure(Error.invalidData))
        }
        let field = generateHeaderFields(using: accessToken)
        _ = httpClient.post(reqBody, to: url.appending(path: "/user"), field: field) { [weak self] result in
            guard self != nil else { return }
            if case let .success((data, response)) = result {
                if response.isOK, let user = try? AddUserMapper.map(data: data) {
                    completion(.success(user))
                } else if response.isUserAlreadyExists {
                    completion(.failure(Error.userAlreadyExists))
                } else if response.isValidationError {
                    completion(.failure(Error.validation))
                } else {
                    completion(.failure(Error.invalidData))
                }
            } else {
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func generateHeaderFields(using accessToken: String) -> [String: String]{
        ["Content-Type": "application/json",
          "Authorization": "Bearer \(accessToken)"]
    }
}
