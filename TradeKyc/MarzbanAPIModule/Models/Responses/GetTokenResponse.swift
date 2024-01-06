//
//  GetTokenResponse.swift
//  MarzbanAPIModule
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

public struct GetTokenResponse: Codable {
    public let access_token: String?
    public let token_type: String?
    
    public init(access_token: String?, token_type: String?) {
        self.access_token = access_token
        self.token_type = token_type
    }
}
