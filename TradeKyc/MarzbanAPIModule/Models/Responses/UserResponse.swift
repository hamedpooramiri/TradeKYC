//
//  UserResponse.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation
import TradeKyc

public struct UserResponse: Codable {
    public let proxies: Proxies?
    public let expire, dataLimit: Int?
    public let dataLimitResetStrategy: String?
    public let inbounds: Inbounds?
    public let note: String?
    public let subUpdatedAt, subLastUserAgent, onlineAt, onHoldExpireDuration: Date?
    public let onHoldTimeout, username, status: String?
    public let usedTraffic, lifetimeUsedTraffic: Int?
    public let createdAt: String?
    public let links: [String]?
    public let subscriptionURL: String?
    public let excludedInbounds: Inbounds?
    
    enum CodingKeys: String, CodingKey {
        case proxies, expire
        case dataLimit = "data_limit"
        case dataLimitResetStrategy = "data_limit_reset_strategy"
        case inbounds, note
        case subUpdatedAt = "sub_updated_at"
        case subLastUserAgent = "sub_last_user_agent"
        case onlineAt = "online_at"
        case onHoldExpireDuration = "on_hold_expire_duration"
        case onHoldTimeout = "on_hold_timeout"
        case username, status
        case usedTraffic = "used_traffic"
        case lifetimeUsedTraffic = "lifetime_used_traffic"
        case createdAt = "created_at"
        case links
        case subscriptionURL = "subscription_url"
        case excludedInbounds = "excluded_inbounds"
    }
    
    public var user: User {
        User(username: username ?? "", subscriptionURL: subscriptionURL ?? "", links: links ?? [])
    }

}
