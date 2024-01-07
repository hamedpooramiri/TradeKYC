//
//  AppCell.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/5/24.
//

import UIKit

public final class AppCell: UITableViewCell {
    @IBOutlet public private(set) weak var iconImageView: UIImageView!
    @IBOutlet public private(set) weak var appNameLabel: UILabel!
    @IBOutlet public private(set) weak var actionLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
    }
    
    public override func layoutSubviews() {
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 8
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
