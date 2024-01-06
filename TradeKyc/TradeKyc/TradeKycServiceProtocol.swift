//
//  TradeKycServiceProtocol.swift
//  TradeKyc
//
//  Created by hamedpouramiri on 1/4/24.
//

import Foundation

public protocol TradeKycServiceProtocol {
    typealias GetAdminResult = Result<Admin, Swift.Error>
    func getAdmin(completion: @escaping (GetAdminResult) -> Void)
}
