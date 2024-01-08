//
//  UIRefreshControl+TestHelpers.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/7/24.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
