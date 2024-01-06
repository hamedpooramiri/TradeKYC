//
//  AddUserBodyRequest.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/1/24.
//

import Foundation

struct AddUserBodyRequest: Encodable {
    let username: String
    let proxies: Proxies
    let inbounds: Inbounds
    let expire: Int
    let dataLimit: Int
    let dataLimitResetStrategy: String = "no_reset"
    let note: String = ""
    let onHoldTimeout: String? = nil
    let status: String = "active"
    let onHoldExpireDuration: Int = 0

    enum CodingKeys: String, CodingKey {
        case username, proxies, inbounds, expire
        case dataLimit = "data_limit"
        case dataLimitResetStrategy = "data_limit_reset_strategy"
        case status, note
        case onHoldTimeout = "on_hold_timeout"
        case onHoldExpireDuration = "on_hold_expire_duration"
    }

    init(username: String, proxies: Proxies, inbounds: Inbounds, expire: Int, dataLimit: Int) {
        self.username = username
        self.proxies = proxies
        self.inbounds = inbounds
        self.expire = expire
        self.dataLimit = dataLimit
    }
}
