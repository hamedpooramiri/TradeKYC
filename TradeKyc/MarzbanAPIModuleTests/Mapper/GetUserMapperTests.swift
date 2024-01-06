//
//  GetUserMapperTests.swift
//  MarzbanAPIModuleTests
//
//  Created by hamedpouramiri on 1/2/24.
//

import XCTest
import TradeKyc
import APIModule
import MarzbanAPIModule

final class GetUserMapperTests: XCTestCase {

    func test_map_deliversData() throws {
        let json: [String : Any?] = [
            "proxies": [
                "vmess": [
                  "id": "35e4e39c-7d5c-4f4b-8b71-558e4f37ff53"
                ],
                "vless": [
                  "id": "b1bcb064-aeef-4931-9312-3df07a286ce8",
                  "flow": ""
                ]
              ],
              "expire": nil,
              "data_limit": nil,
              "data_limit_reset_strategy": "no_reset",
              "inbounds": [
                "vmess": [
                  "VMess NoTLS"
                ],
                "vless": [
                  "VLESS + WS",
                  "Test VLESS + WS"
                ]
              ],
              "note": "",
              "sub_updated_at": nil,
              "sub_last_user_agent": nil,
              "online_at": nil,
              "on_hold_expire_duration": nil,
              "on_hold_timeout": "2023-11-03T20:30:00",
              "username": "user1234",
              "status": "active",
              "used_traffic": 0,
              "lifetime_used_traffic": 0,
              "created_at": "2024-01-02T16:27:12.683931",
              "links": [
                "vmess://eyJhZGQiOiAidC5tZS95b3VyY2hhbmVsIFx1MDYyZVx1MDYzMVx1MDZjY1x1MDYyZiBcdTA2MjJcdTA2Y2MgXHUwNjdlXHUwNmNjIFx1MDYyYlx1MDYyN1x1MDYyOFx1MDYyYSBcdTA2MmFcdTA2MzFcdTA2Y2NcdTA2MmYiLCAiYWlkIjogIjAiLCAiaG9zdCI6ICIiLCAiaWQiOiAiMzVlNGUzOWMtN2Q1Yy00ZjRiLThiNzEtNTU4ZTRmMzdmZjUzIiwgIm5ldCI6ICJ3cyIsICJwYXRoIjogIi9uYXZpZ2F0ZSIsICJwb3J0IjogODAwMSwgInBzIjogIlx1ZDgzZFx1ZGM2NHx1c2VyMTIzNHwgXHVkODNkXHVkZWQyLS0+VC5tZS95b3VyY2hhbmVsIiwgInNjeSI6ICJhdXRvIiwgInRscyI6ICJub25lIiwgInR5cGUiOiAiIiwgInYiOiAiMiJ9",
                "vmess://eyJhZGQiOiAidC5tZS95b3VyY2hhbmVsIFx1MDYyOFx1MDYyNyBcdTA2YTlcdTA2Y2NcdTA2NDQgXHUwNjMzXHUwNjQ4XHUwNmNjXHUwNjg2IiwgImFpZCI6ICIwIiwgImhvc3QiOiAiIiwgImlkIjogIjM1ZTRlMzljLTdkNWMtNGY0Yi04YjcxLTU1OGU0ZjM3ZmY1MyIsICJuZXQiOiAid3MiLCAicGF0aCI6ICIvbmF2aWdhdGUiLCAicG9ydCI6IDgwMDEsICJwcyI6ICJcdWQ4M2RcdWRjY2FcdTIyMWUgXHUyM2YwXHUyMjFlIGRheSA6XHUwNjI4XHUwNjI3XHUwNjQyXHUwNmNjXHUwNjQ1XHUwNjI3XHUwNjQ2XHUwNjJmXHUwNjQ3IiwgInNjeSI6ICJhdXRvIiwgInRscyI6ICJub25lIiwgInR5cGUiOiAiIiwgInYiOiAiMiJ9",
                "vless://b1bcb064-aeef-4931-9312-3df07a286ce8@cdnde1.pablosoft.com:8880?security=none&type=ws&host=&headerType=&path=speedtest.net#%F0%9F%87%A9%F0%9F%87%AA%20GERMANY%201%F0%9F%9A%80",
                "vless://b1bcb064-aeef-4931-9312-3df07a286ce8@sub.pablosoft.com:8881?security=none&type=ws&host=&headerType=&path=speedtest.net#%F0%9F%87%A9%F0%9F%87%AA%20GERMANY%201%20%F0%9F%87%AE%F0%9F%87%B7%F0%9F%9A%80",
                "vless://b1bcb064-aeef-4931-9312-3df07a286ce8@cdnfnl.pablosoft.com:8880?security=none&type=ws&host=&headerType=&path=speedtest.net#%F0%9F%87%AB%F0%9F%87%AE%20FInland%201%20%F0%9F%9A%80",
                "vless://b1bcb064-aeef-4931-9312-3df07a286ce8@sub.pablosoft.com:8882?security=none&type=ws&host=&headerType=&path=speedtest.net#%F0%9F%87%AB%F0%9F%87%AE%20FInland%201%20%F0%9F%87%AE%F0%9F%87%B7%20%F0%9F%9A%80",
                "vless://b1bcb064-aeef-4931-9312-3df07a286ce8@cdntr.pablosoft.com:8880?security=none&type=ws&host=&headerType=&path=speedtest.net#%F0%9F%87%B9%F0%9F%87%B7%20turkey%201%20%F0%9F%9A%80",
                "vless://b1bcb064-aeef-4931-9312-3df07a286ce8@sub.pablosoft.com:8883?security=none&type=ws&host=&headerType=&path=speedtest.net#%F0%9F%87%B9%F0%9F%87%B7%20turkey%201%20%F0%9F%87%AE%F0%9F%87%B7%20%F0%9F%9A%80"
              ],
              "subscription_url": "https://sub.pablosoft.com/sub/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMTIzNCIsImFjY2VzcyI6InN1YnNjcmlwdGlvbiIsImlhdCI6MTcwNDIxMzA1NX0.BXeDACDy4OpJe81TNqWP5-rPGj2fT-I6tJ2RWycmtbM",
              "excluded_inbounds": [
                "vmess": [],
                "vless": []
              ]
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: json)
        let user = try GetUserMapper.map(data: jsonData)
        XCTAssertEqual(user.links.count, 8)
        XCTAssertEqual(user.subscriptionURL, "https://sub.pablosoft.com/sub/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyMTIzNCIsImFjY2VzcyI6InN1YnNjcmlwdGlvbiIsImlhdCI6MTcwNDIxMzA1NX0.BXeDACDy4OpJe81TNqWP5-rPGj2fT-I6tJ2RWycmtbM")
    }
    
    func test_map_deliversErrorOnMissingData() {
        let data = "not valid data".data(using: .utf8)!
        let response = try? GetUserMapper.map(data: data)
        XCTAssertNil(response)
    }

}
