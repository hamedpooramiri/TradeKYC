//
//  ServiceSpy.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/6/24.
//

import TradeKyc

final class ServiceSpy: TradeKycServiceProtocol, MarzbanServiceProtocol {

    enum Request: Equatable {
        case getAdmin
        case getToken(username: String, password: String)
        case getUser(username: String, accessToken: String)
        case addUser(username: String, accessToken: String)
    }

    private(set) var capturedRequests = [Request]()
    private(set) var getAdminCapturedCompletions = [(GetAdminResult) -> Void]()
    private(set) var getTokenCapturedCompletions = [(GetTokenResult) -> Void]()
    private(set) var getUserCapturedCompletions = [(GetUserResult) -> Void]()
    private(set) var addUserCapturedCompletions = [(AddUserResult) -> Void]()

    func getAdmin(completion: @escaping (GetAdminResult) -> Void) {
        capturedRequests.append(.getAdmin)
        getAdminCapturedCompletions.append(completion)
    }
    
    func getToken(username: String, password: String, completion: @escaping (GetTokenResult) -> Void) {
        capturedRequests.append(.getToken(username: username, password: password))
        getTokenCapturedCompletions.append(completion)
    }
    
    func getUser(username: String, accessToken: String, completion: @escaping (GetUserResult) -> Void) {
        capturedRequests.append(.getUser(username: username, accessToken: accessToken))
        getUserCapturedCompletions.append(completion)
    }
    
    func addUser(username: String, accessToken: String, completion: @escaping (AddUserResult) -> Void) {
        capturedRequests.append(.addUser(username: username, accessToken: accessToken))
        addUserCapturedCompletions.append(completion)
    }

    func complete(with admin: Admin, at index: Int = 0) {
        getAdminCapturedCompletions[index](.success(admin))
    }
    
    func complete(with token: String, at index: Int = 0) {
        getTokenCapturedCompletions[index](.success(token))
    }

    func completeGetUser(with user: User, at index: Int = 0) {
        getUserCapturedCompletions[index](.success(user))
    }

    func completeAddUser(with user: User, at index: Int = 0) {
        addUserCapturedCompletions[index](.success(user))
    }

    func completeGetAdmin(with error: Error, at index: Int = 0) {
        getAdminCapturedCompletions[index](.failure(error))
    }

    func completeGetToken(with error: MarzbanServiceError, at index: Int = 0) {
        getTokenCapturedCompletions[index](.failure(error))
    }

    func completeGetUser(with error: MarzbanServiceError, at index: Int = 0) {
        getUserCapturedCompletions[index](.failure(error))
    }
    
    func completeAddUser(with error: MarzbanServiceError, at index: Int = 0) {
        addUserCapturedCompletions[index](.failure(error))
    }
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
