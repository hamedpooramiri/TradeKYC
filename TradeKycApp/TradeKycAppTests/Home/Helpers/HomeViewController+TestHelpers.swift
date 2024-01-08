//
//  HomeViewController+TestHelpers.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/7/24.
//
import TradeKyciOS
import UIKit

extension HomeViewController {
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            prepareForFirstAppearance()
        }
        
        beginAppearanceTransition(true, animated: false) // ViewWillAppear
        endAppearanceTransition() // ViewIsAppearing+ViewDidAppear
    }

    private func prepareForFirstAppearance() {
        setSmallFrameToPreventRenderingCells()
        replaceRefreshControlWithFakeForiOS17PlusSupport()
    }

    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }

    private func replaceRefreshControlWithFakeForiOS17PlusSupport() {
        let fakeRefreshControl = FakeUIRefreshControl()
        
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fakeRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }
        refreshControl = fakeRefreshControl
    }

    private class FakeUIRefreshControl: UIRefreshControl {
        private var _isRefreshing = false
        
        override var isRefreshing: Bool { _isRefreshing }
        
        override func beginRefreshing() {
            _isRefreshing = true
        }
        
        override func endRefreshing() {
            _isRefreshing = false
        }
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    var errorMessage: String? {
        return errorView.message
    }
    
    func numberOfRows(in section: Int) -> Int {
        tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section) : 0
    }
    
    func cell(row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRows(in: section) > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

extension HomeViewController {
    func numberOfRenderedAppCells() -> Int {
        numberOfRows(in: appSection)
    }
    
    func numberOfRenderedQrCodeCells() -> Int {
        numberOfRows(in: qrCodeSection)
    }

    func appCellTitle(at row: Int) -> String? {
        appView(at: row)?.appNameLabel.text
    }
    
    func appCellActionTitle(at row: Int) -> String? {
        appView(at: row)?.actionLabel.text
    }
    
    func appCellImage(at row: Int) -> UIImage? {
        appView(at: row)?.iconImageView.image
    }
    
    private func appView(at row: Int) -> AppCell? {
        cell(row: row, section: appSection) as? AppCell
    }

    private var qrCodeSection: Int { 0 }
    private var appSection: Int { 1 }
}

extension HomeViewController {
    
    @discardableResult
    func simulateAppCellViewVisible(at index: Int) -> AppCell? {
        return appCellView(at: index) as? AppCell
    }

    func simulateTapOnAppCellView(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: appSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func appCellView(at row: Int) -> UITableViewCell? {
        cell(row: row, section: appSection)
    }
}
