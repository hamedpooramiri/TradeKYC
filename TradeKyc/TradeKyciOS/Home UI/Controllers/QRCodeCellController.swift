//
//  QRCodeCellController.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/5/24.
//

import Foundation
import UIKit

public final class QRCodeCellController: NSObject {
    private let cell = QRCodeCell()
    private let qrCode: String

    public init(qrCode: String) {
        self.qrCode = qrCode
    }
}

extension QRCodeCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.display(qrImage: QRCodeGenerator.shared.generateQRImage(stringQR: qrCode, withSizeRate: 100))
        return cell
    }
}
