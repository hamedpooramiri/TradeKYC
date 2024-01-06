//
//  QRCodeCell.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/5/24.
//

import UIKit

class QRCodeCell: UITableViewCell {

    private lazy var QRImageView: UIImageView = {
        let view = UIImageView()
        contentView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].map { constraint in
            constraint.priority = .init(rawValue: 999)
            return constraint
        })

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5)
        ])
        
        return view
    }()
 
    public func display(qrImage: UIImage) {
        QRImageView.image = qrImage
    }

}
