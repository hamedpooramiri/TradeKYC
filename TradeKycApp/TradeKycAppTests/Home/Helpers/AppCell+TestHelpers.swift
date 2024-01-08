//
//  AppCell+TestHelpers.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/7/24.
//

import TradeKyciOS

extension AppCell {
    
    var appNameText: String? {
        return appNameLabel.text
    }
    
    var appActionText: String? {
        return actionLabel.text
    }
    
    var renderedImage: Data? {
        return iconImageView.image?.pngData()
    }
}
