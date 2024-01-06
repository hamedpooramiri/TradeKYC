//
//  GetAdminMapper.swift
//  TradeKycAPIModule
//
//  Created by hamedpouramiri on 1/3/24.
//

import Foundation
import TradeKyc

public final class GetAdminMapper {
    public static func map(data: Data) throws -> Admin {
        try JSONDecoder().decode(AdminResponse.self, from: data).adminModel
    }
}
