//
//  MockData.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation
import TradeKyc

func makeAnyAdminResponse() -> (model: Admin, jsonData: Data) {
    let json: [String : String] = [
        "abcd": "admin",
        "efgh": "123456"
    ]
    let jsonData = try! JSONSerialization.data(withJSONObject: json)
    let admin = Admin(username: json["abcd"]!, password: json["efgh"]!)
    return (admin, jsonData)
}
