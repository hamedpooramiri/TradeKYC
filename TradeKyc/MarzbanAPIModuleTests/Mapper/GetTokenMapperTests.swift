//
//  GetTokenMapperTests.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//


import XCTest
import APIModule
import MarzbanAPIModule

final class GetTokenMapperTests: XCTestCase {
    
    func test_encodeBodyRequest_deliversData() throws {
        let data = try GetTokenMapper.encodeBodyRequest(username: "any username", password: "123456")
        XCTAssertNotNil(data)
    }
    
    func test_map_deliversData() throws {
        let json = [
            "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJpT1N0ZXN0IiwiYWNjZXNzIjoiYWRtaW4iLCJpYXQiOjE3MDQyMDc4MDcsImV4cCI6MTcwNDI5NDIwN30.SKIVx_tB0Aiew6V-xfvCDnrsJrjJ_a-o4NShuZedoeQ",
            "token_type": "bearer"
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        let data = try GetTokenMapper.map(data: jsonData)
        XCTAssertNotNil(data)
    }
    
    func test_map_deliversErrorOnMissingData() {
        let data = "not valid data".data(using: .utf8)!
        let response = try? GetTokenMapper.map(data: data)
        XCTAssertNil(response)
    }
}
