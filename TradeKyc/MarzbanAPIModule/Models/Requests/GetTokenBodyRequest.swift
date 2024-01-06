//
//  GetTokenBodyRequest.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

struct GetTokenBodyRequest: Encodable {
    let username: String
    let password: String
}
