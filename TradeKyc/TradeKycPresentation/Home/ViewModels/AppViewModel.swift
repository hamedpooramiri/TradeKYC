//
//  AppViewModel.swift
//  TradeKycPresentation
//
//  Created by hamedpouramiri on 1/6/24.
//

import Foundation

public struct AppViewModel: Equatable {

    public let name: String
    public let storeUrl: URL
    public let appUrl: URL
    public let image: Data
    public var actionText: String

    public init(name: String, storeUrl: URL, appUrl: URL, image: Data, actionText: String) {
        self.name = name
        self.storeUrl = storeUrl
        self.appUrl = appUrl
        self.image = image
        self.actionText = actionText
    }
}
