//
//  QRCodeCellController.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/5/24.
//

import Foundation
import TradeKycPresentation
import UIKit

public final class QRCodeCellController: NSObject {
    private let cell = QRCodeCell()
    private let viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

extension QRCodeCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.display(qrImage: QRCodeGenerator.shared.generateQRImage(stringQR: viewModel.subscriptionLink, withSizeRate: 100))
        return cell
    }
}
