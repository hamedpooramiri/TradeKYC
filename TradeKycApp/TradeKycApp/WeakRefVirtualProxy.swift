//
//  WeakRefVirtualProxy.swift
//  TradeKycApp
//
//  Created by hamedpouramiri on 1/7/24.
//

import Foundation
import TradeKycPresentation

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: HomePresenterErrorView where T: HomePresenterErrorView {
    func display(error: String) {
        object?.display(error: error)
    }
}

extension WeakRefVirtualProxy: HomePresenterLoadingView where T: HomePresenterLoadingView {
    func display(isLoading: Bool) {
        object?.display(isLoading: isLoading)
    }
}
