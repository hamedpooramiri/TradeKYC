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
    public let imageName: String
    
    public init(name: String, storeUrl: URL, appUrl: URL, imageName: String) {
        self.name = name
        self.storeUrl = storeUrl
        self.appUrl = appUrl
        self.imageName = imageName
    }
    
    static var defaultApps: [Self] = [
    
    
    ]
}
