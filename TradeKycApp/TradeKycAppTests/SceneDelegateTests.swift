//
//  SceneDelegateTests.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/8/24.
//

import XCTest
import TradeKyciOS
@testable import TradeKycApp

class SceneDelegateTests: XCTestCase {

    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate(httpClient: HTTPClientStub(), marzbanServiceURL: marzbanServiceURL, tradeKycServiceURL: tradeKycServiceURL)
        sut.window = window
        
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate(httpClient: HTTPClientStub(), marzbanServiceURL: marzbanServiceURL, tradeKycServiceURL: tradeKycServiceURL)
        sut.window = UIWindowSpy()
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertTrue(topController is HomeViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead")
    }
    
    private class UIWindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0
        
        override func makeKeyAndVisible() {
            makeKeyAndVisibleCallCount = 1
        }
    }
    
    private var marzbanServiceURL: URL {
        URL(string: "www.marzban.com")!
    }
    
    private var tradeKycServiceURL: URL {
        URL(string: "www.tradekyc.com")!
    }
}
