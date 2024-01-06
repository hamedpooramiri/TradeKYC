//
//  AppCellController.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/5/24.
//

import UIKit
import TradeKycPresentation

public final class AppCellController: NSObject {

    private var cell: AppCell?
    private let appName: String
    private let actionTitle: String
    private let imageIcon: UIImage
    private var onSelection: (()-> Void)?

    public init(appName: String, actionTitle: String, imageIcon: UIImage, selection: @escaping () -> Void) {
        self.appName = appName
        self.actionTitle = actionTitle
        self.imageIcon = imageIcon
        self.onSelection = selection
    }

}

extension AppCellController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.actionLabel.text = actionTitle
        cell?.appNameLabel.text = appName
        cell?.iconImageView.image = imageIcon
        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?()
    }

}
