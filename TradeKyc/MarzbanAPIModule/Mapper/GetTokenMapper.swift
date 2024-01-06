//
//  GetTokenMapper.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import Foundation

public final class GetTokenMapper {
    
    public init() {}
    
    static public func encodeBodyRequest(username: String, password: String) throws -> Data {
        let body = GetTokenBodyRequest(username: username, password: password)
        return try JSONEncoder().encode(body)
    }
    
    static public func map(data: Data) throws -> GetTokenResponse {
        try JSONDecoder().decode(GetTokenResponse.self, from: data)
    }

}
