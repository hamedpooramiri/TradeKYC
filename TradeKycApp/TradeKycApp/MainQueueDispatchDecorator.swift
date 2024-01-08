//
//  MainQueueDispatchDecorator.swift
//  TradeKycApp
//
//  Created by hamedpouramiri on 1/8/24.
//
import TradeKyc
import Foundation

final public class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    private func dispatch(completion: @escaping ()-> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: MarzbanServiceProtocol where T == MarzbanServiceProtocol {
    public func getToken(username: String, password: String, completion: @escaping (GetTokenResult) -> Void) {
        decoratee.getToken(username: username, password: password) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
    
    public func getUser(username: String, accessToken: String, completion: @escaping (GetUserResult) -> Void) {
        decoratee.getUser(username: username, accessToken: accessToken) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
    
    public func addUser(username: String, accessToken: String, completion: @escaping (AddUserResult) -> Void) {
        decoratee.addUser(username: username, accessToken: accessToken) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: TradeKycServiceProtocol where T == TradeKycServiceProtocol {
    public func getAdmin(completion: @escaping (GetAdminResult) -> Void) {
        decoratee.getAdmin { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }  
}
