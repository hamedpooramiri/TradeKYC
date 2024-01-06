//
//  AddUserMapperTests.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import XCTest
import MarzbanAPIModule

final class AddUserMapperTests: XCTestCase {

    func test_encodeBodyRequest_deliversData() throws {
        let data = try AddUserMapper.encodeBodyRequest(username: "any username")
        XCTAssertNotNil(data)
    }
    
    func test_map_deliversAddedUser() throws {
        let response = makeAnyUserResponse()
        let user = try AddUserMapper.map(data: response.jsonData)
        XCTAssertNotNil(user)
        XCTAssertEqual(user, response.model)
    }
    
    func test_map_deliversErrorOnMissingData() {
        let data = "not valid data".data(using: .utf8)!
        let user = try? AddUserMapper.map(data: data)
        XCTAssertNil(user)
    }
}
