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
    private let viewModel: AppViewModel
    private var onSelection: (()-> Void)?

    public init(viewModel: AppViewModel, selection: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onSelection = selection
    }

}

extension AppCellController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        cell?.actionLabel.text = viewModel.actionText
        cell?.appNameLabel.text = viewModel.name
        cell?.iconImageView.image = .init(data: viewModel.image)
        return cell!
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelection?()
    }

}
