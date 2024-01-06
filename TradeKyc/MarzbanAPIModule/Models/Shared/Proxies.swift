//
//  Proxies.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

public struct Proxies: Codable {
    public let vmess: Vmess?
    public let vless: Vless?
}

public struct Vless: Codable {
    public let id, flow: String
}


public struct Vmess: Codable {
    public let id: String
}
