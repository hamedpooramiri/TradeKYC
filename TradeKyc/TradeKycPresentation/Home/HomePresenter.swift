//
//  HomePresenter.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/4/24.
//

import Foundation
import TradeKyc

public protocol HomePresenterLoadingView {
    func display(isLoading: Bool)
}

public protocol HomePresenterErrorView {
    func display(error: String)
}

public protocol HomePresenterView {
    func display(viewModel: HomeViewModel)
}

public protocol HomePresenterInput {
    func requestData(withDeviceID deviceID: String?)
}

public final class HomePresenter: HomePresenterInput {

    public struct NoDeviceIDError: Error {
        public init() {}
    }

    private var marzbanService: MarzbanServiceProtocol
    private var tradeKycService: TradeKycServiceProtocol
    
    private var errorView: HomePresenterErrorView
    private var loadingView: HomePresenterLoadingView
    private var view: HomePresenterView

    private var deviceID: String = ""

    public init(tradeKycService: TradeKycServiceProtocol, marzbanService: MarzbanServiceProtocol, errorView: HomePresenterErrorView, loadingView: HomePresenterLoadingView, view: HomePresenterView) {
        self.tradeKycService = tradeKycService
        self.marzbanService = marzbanService
        self.errorView = errorView
        self.loadingView = loadingView
        self.view = view
    }
    
    public func requestData(withDeviceID deviceID: String?) {
        guard let deviceID = deviceID else  {
            return errorView.display(error: NoDeviceIDError().localizedDescription)
        }
        self.deviceID = deviceID
        loadingView.display(isLoading: true)
        tradeKycService.getAdmin { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(admin):
                self.getToken(with: admin)
            case let .failure(error):
                self.errorView.display(error: error.localizedDescription)
                self.loadingView.display(isLoading: false)
            }
        }
    }
    
    private func getToken(with admin: Admin) {
        marzbanService.getToken(username: admin.username, password: admin.password) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(accessToken):
                self.getUser(accessToken: accessToken)
            case let .failure(error):
                self.errorView.display(error: error.localizedDescription)
                self.loadingView.display(isLoading: false)
            }
        }
    }

    private func getUser(accessToken: String) {
        marzbanService.getUser(username: deviceID, accessToken: accessToken) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(user):
                self.view.display(viewModel: HomeViewModel(subscriptionLink: user.subscriptionURL, links: user.links))
                self.loadingView.display(isLoading: false)
            case let .failure(error):
                if error == .notFound {
                    self.addUser(accessToken: accessToken)
                } else {
                    self.errorView.display(error: error.localizedDescription)
                    self.loadingView.display(isLoading: false)
                }
            }
        }
    }

    private func addUser(accessToken: String) {
        marzbanService.addUser(username: deviceID, accessToken: accessToken) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(user):
                self.view.display(viewModel: HomeViewModel(subscriptionLink: user.subscriptionURL, links: user.links))
            case let .failure(error):
                self.errorView.display(error: error.localizedDescription)
            }
            self.loadingView.display(isLoading: false)
        }
    }

}

