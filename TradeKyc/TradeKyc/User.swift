//
//  User.swift
//  TradeKyc
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

public struct User: Equatable {
    public let username: String
    public let subscriptionURL: String
    public let links: [String]
    
    public init(username: String, subscriptionURL: String, links: [String]) {
        self.username = username
        self.subscriptionURL = subscriptionURL
        self.links = links
    }
}
