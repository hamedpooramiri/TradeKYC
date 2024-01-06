//
//  GetAdminMapperTests.swift
//  TradeKycAPIModuleTests
//
//  Created by hamedpouramiri on 1/3/24.
//

import XCTest
import TradeKycAPIModule

final class GetAdminMapperTests: XCTestCase {

    func test_map_deliversData() throws {
        let response = makeAnyAdminResponse()
        let model = try GetAdminMapper.map(data: response.jsonData)
        XCTAssertEqual(model.username, response.model.username)
        XCTAssertEqual(model.password, response.model.password)
    }
    
    func test_map_deliversErrorOnMissingData() {
        let data = "not valid data".data(using: .utf8)!
        let response = try? GetAdminMapper.map(data: data)
        XCTAssertNil(response)
    }
}
