//
//  Admin.swift
//  TradeKyc
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

public struct Admin: Equatable {
    public let username: String
    public let password: String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
