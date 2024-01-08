//
//  TradeKycAcceptanceTests.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/8/24.
//

import XCTest
import TradeKyc
import APIModule
import TradeKyciOS
@testable import TradeKycApp

class TradeKycAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysFeedsWhenCustomerHasConnectivity() {
        let client = HTTPClientStub()
        client.stub(completions: [
            { url in .success(self.response(for: url)) },
            { url in .success(self.response(for: url)) },
            { url in .success(self.response(for: url)) }
        ])
        let view = launch(httpClient: client)
        XCTAssertEqual(view.numberOfSections(in: view.tableView), 1)
        XCTAssertEqual(view.numberOfRows(in: 0), 1)
        XCTAssertEqual(view.numberOfRows(in: 1), 1)
    }
    
    func test_onLaunch_createUserAndDisplaysFeedsWhenCustomerHasConnectivity() {
        let client = HTTPClientStub()
        client.stub(completions: [
            { url in .success(self.response(for: url)) },
            { url in .success(self.response(for: url)) },
            { url in .failure(MarzbanServiceError.notFound) },
            { url in .success(self.response(for: url)) },
        ])
        let view = launch(httpClient: client)
        XCTAssertEqual(view.numberOfSections(in: view.tableView), 1)
        XCTAssertEqual(view.numberOfRows(in: 0), 1)
        XCTAssertEqual(view.numberOfRows(in: 1), 1)
    }

    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivity() {
        let client = HTTPClientStub()
        client.stub(completions: [
            { _ in .failure(anyNSError()) }
        ])
        let view = launch(httpClient: client)
        XCTAssertEqual(view.numberOfSections(in: view.tableView), 1)
        XCTAssertEqual(view.numberOfRows(in: 0), 0)
        XCTAssertEqual(view.numberOfRows(in: 1), 0)
    }

    // MARK: - Helpers
    
    private func launch(httpClient: HTTPClientStub) -> HomeViewController {
        let sut = SceneDelegate(httpClient: httpClient, marzbanServiceURL: marzbanServiceURL, tradeKycServiceURL: tradeKycServiceURL)
        sut.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 1))
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        let vc = nav?.topViewController as! HomeViewController
        vc.simulateAppearance()
        return vc
    }

    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }

    private func makeData(for url: URL) -> Data {
        switch url.path {
        case "\(tradeKycServiceURL.path)": return makeAdminData()
        case "\(marzbanServiceURL.path)/admin/token": return makeTokenData()
        case "\(marzbanServiceURL.path)/user/\(deviceID)": return makeUserData() // get user
        case "\(marzbanServiceURL.path)/user": return makeUserData()
        default:
            return Data()
        }
    }

    private func makeAdminData() -> Data {
        try! JSONSerialization.data(withJSONObject:[
                "abcd": "usernamae",
                "efgh": "password"
            ] as [String: Any]
        )
    }

    private func makeTokenData() -> Data {
        try! JSONSerialization.data(withJSONObject:[
                "access_token": "any_token",
                "token_type": "token_type"
            ] as [String: Any]
        )
    }

    private func makeUserData() -> Data {
        try! JSONSerialization.data(withJSONObject: [
            "proxies": [
                "vmess": [
                    "id": "35e4e39c-7d5c-4f4b-8b71-558e4f37ff53"
                ],
                "vless": [
                    "id": "b1bcb064-aeef-4931-9312-3df07a286ce8",
                    "flow": ""
                ]
            ],
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
            "on_hold_timeout": "2023-11-03T20:30:00",
            "username": "user1234",
            "status": "active",
            "used_traffic": 0,
            "lifetime_used_traffic": 0,
            "created_at": "2024-01-02T16:27:12.683931",
            
        ] as [String: Any])
    }

    private var marzbanServiceURL: URL {
        URL(string: "www.marzban.com")!
    }
    
    private var tradeKycServiceURL: URL {
        URL(string: "www.tradekyc.com")!
    }
    
    private var deviceID: String {
        UIDevice.current.identifierForVendor!.uuidString
    }
}
