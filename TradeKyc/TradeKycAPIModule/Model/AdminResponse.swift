//
//  AdminResponse.swift
//  TradeKycAPIModule
//
//  Created by hamedpouramiri on 1/3/24.
//

import Foundation
import TradeKyc

struct AdminResponse: Decodable {

    let user: String?
    let password: String?
    
    enum CodingKeys: String, CodingKey {
        case user = "abcd"
        case password = "efgh"
    }

    public var adminModel: Admin {
        Admin(username: user ?? "", password: password ?? "")
    }
}
