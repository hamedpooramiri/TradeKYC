//
//  HomeUIComposer.swift
//  TradeKycApp
//
//  Created by hamedpouramiri on 1/6/24.
//

import UIKit
import TradeKyc
import TradeKycPresentation
import TradeKyciOS

public final class HomeUIComposer {
    private init() {}

    public static func homeComposedWith(tradeKycService: TradeKycServiceProtocol, marzbanService: MarzbanServiceProtocol, apps: [AppViewModel], onAppSelection: @escaping (AppViewModel, HomeViewModel) -> Void) -> HomeViewController {
        let controller = makeHomeViewController()
        let adapter = HomePresentationViewAdapter(viewController: controller, apps: apps, onAppSelection: onAppSelection)
        let presenter = HomePresenter(tradeKycService: MainQueueDispatchDecorator(decoratee: tradeKycService) ,
                                      marzbanService: MainQueueDispatchDecorator(decoratee: marzbanService),
                                      errorView: WeakRefVirtualProxy(controller),
                                      loadingView: WeakRefVirtualProxy(controller),
                                      view: adapter)
        controller.presenter = presenter
        return controller
    }

    private static func makeHomeViewController() -> HomeViewController {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        let homeController = storyboard.instantiateInitialViewController() as! HomeViewController
        return homeController
    }
}


