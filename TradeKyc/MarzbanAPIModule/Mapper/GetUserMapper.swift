//
//  GetUserMapper.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation
import TradeKyc

public final class GetUserMapper {
    static public func map(data: Data) throws -> User {
        try JSONDecoder().decode(UserResponse.self, from: data).user
    }
}
