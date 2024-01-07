//
//  HomeViewModel.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/5/24.
//

import Foundation
import TradeKyc

public struct HomeViewModel: Equatable {

    public let subscriptionLink: String
    public let links: [String]
    public var apps: [AppViewModel] = []
    
    public init(subscriptionLink: String, links: [String]) {
        self.subscriptionLink = subscriptionLink
        self.links = links
    }

    public init(user: User) {
        self.subscriptionLink = user.subscriptionURL
        self.links = user.links
    }
}
