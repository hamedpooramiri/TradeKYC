//
//  UITableView+Dequeueing.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/6/24.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
