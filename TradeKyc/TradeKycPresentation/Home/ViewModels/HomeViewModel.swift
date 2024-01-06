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
    public let apps: [AppViewModel]
    
    public init(subscriptionLink: String, links: [String], apps: [AppViewModel]) {
        self.subscriptionLink = subscriptionLink
        self.links = links
        self.apps = apps
    }

    public init(user: User, apps: [AppViewModel]) {
        self.subscriptionLink = user.subscriptionURL
        self.links = user.links
        self.apps = apps
    }
}
