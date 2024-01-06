//
//  AddUserMapper.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/3/24.
//

import Foundation
import TradeKyc

public final class AddUserMapper {
    static public func encodeBodyRequest(username: String) throws -> Data {
        let req = AddUserBodyRequest(username: username,
                                     proxies: Proxies(vmess: Vmess(id: "35e4e39c-7d5c-4f4b-8b71-558e4f37ff53"),
                                                      vless: nil),
                                     inbounds: Inbounds(vmess: [], vless: []),
                                     expire: 0,
                                     dataLimit: 0)
        return try JSONEncoder().encode(req)
    }
    
    static public func map(data: Data) throws -> User {
        try JSONDecoder().decode(UserResponse.self, from: data).user
    }
}
