//
//  UIControl+TestHelpers.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/7/24.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                print($0)
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
