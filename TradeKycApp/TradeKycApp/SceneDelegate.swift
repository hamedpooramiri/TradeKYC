//
//  SceneDelegate.swift
//  TradeKycApp
//
//  Created by hamedpouramiri on 1/6/24.
//

import UIKit
import TradeKyc
import MarzbanAPIModule
import TradeKycAPIModule
import APIModule

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var marzbanServiceURL: URL = URL(string: "www.any-url.com")!
    private var tradeKycServiceURL: URL = URL(string: "www.any-url.com")!

    convenience init(httpClient: HTTPClient, marzbanServiceURL: URL, tradeKycServiceURL: URL) {
        self.init()
        self.httpClient = httpClient
        self.marzbanServiceURL = marzbanServiceURL
        self.tradeKycServiceURL = tradeKycServiceURL
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }

    func configureWindow() {
        window?.rootViewController = UINavigationController(
            rootViewController:
                HomeUIComposer.homeComposedWith(tradeKycService: makeTradeKycService(url: tradeKycServiceURL),
                                                marzbanService: makeMarzbanService(url: marzbanServiceURL),
                                                apps: [.init(name: "v2box", storeUrl: URL(string: "www.any-url.com")!, appUrl: URL(string: "www.any-url.com")!, image: Data(), actionText: "")],
                                                onAppSelection: { appViewModel, homeViewModel in
                                                    
                                                })
        )
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private func makeTradeKycService(url: URL) -> TradeKycServiceProtocol {
        TradeKycService(url: url, httpClient: httpClient)
    }

    private func makeMarzbanService(url: URL) -> MarzbanServiceProtocol {
        MarzbanService(url: url, httpClient: httpClient)
    }


}

