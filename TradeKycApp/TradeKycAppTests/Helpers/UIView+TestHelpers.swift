//
//  UIView+TestHelpers.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/7/24.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
