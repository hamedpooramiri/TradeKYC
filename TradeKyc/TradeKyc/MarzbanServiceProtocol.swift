//
//  MarzbanServiceProtocol.swift
//  TradeKyc
//
//  Created by hamedpouramiri on 1/4/24.
//

import Foundation

public protocol MarzbanServiceProtocol {
    typealias Error = MarzbanServiceError
    typealias AddUserResult = Result<User, Error>
    typealias GetUserResult = Result<User, Error>
    typealias GetTokenResult = Result<String, Error>
    func getToken(username: String, password: String, completion: @escaping (GetTokenResult) -> Void)
    func getUser(username: String, accessToken: String, completion: @escaping (GetUserResult) -> Void)
    func addUser(username: String, accessToken: String, completion: @escaping (AddUserResult) -> Void)
}

public enum MarzbanServiceError: Swift.Error {
    case invalidData
    case connectivity
    case userAlreadyExists
    case validation
    case unAuthorized
    case notFound
}
