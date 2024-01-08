//
//  HomeSnapshotTests.swift
//  TradeKyciOSTests
//
//  Created by hamedpouramiri on 1/4/24.
//

import XCTest
import TradeKycPresentation
import TradeKyciOS

final class HomeSnapshotTests: XCTestCase {

    func test_refreshControl_showWhenISLoading() {
        let sut = makeSUT()
        RunLoop.main.run(until: .now)
        sut.display(isLoading: true)

        record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "HOME_WITH_LOAD_INDICATOR_light")
        record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "HOME_WITH_LOAD_INDICATOR_dark")
    }

    func test_listWithErrorMessage() {
        let sut = makeSUT()
        sut.display(error: "This is a\nmulti-line\nerror message")
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light, contentSize: .extraExtraExtraLarge)), named: "LIST_WITH_ERROR_MESSAGE_light_extraExtraExtraLarge")
    }

    func test_emptyList() {
        let sut = makeSUT()
        sut.display(emptyList())

        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "HOME_EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "HOME_EMPTY_LIST_dark")
    }
    
    func test_listWithContent() {
        let sut = makeSUT()
        sut.display(listWithContent(appStub()))

        record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "HOME_LIST_WITH_CONTENT_light")
        record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "HOME_LIST_WITH_CONTENT_dark")
    }

    func test_listWithQRCodeAndContent() {
        let sut = makeSUT()
        sut.display(listWithQrCode(list:listWithContent(appStub())))

        record(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "HOME_LIST_WITH_QR_AND_CONTENT_light")
        record(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "HOME_LIST_WITH_QR_AND_CONTENT_dark")
    }

    // MARK: - Helpers
    
    private func makeSUT() -> HomeViewController {
        let bundle = Bundle(for: HomeViewController.self)
        let storyboard = UIStoryboard(name: "Home", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! HomeViewController
        controller.loadViewIfNeeded()
        return controller
    }

    private func emptyList() -> [CellController] {
        return []
    }

    private func listWithQrCode(list: [CellController]) -> [CellController] {
        [CellController(id: UUID(), QRCodeCellController(viewModel: .init(subscriptionLink: "www.any-url.com", links: [])))] + list
    }

    private func qrCodeCell() -> [CellController] {
        [CellController(id: UUID(), QRCodeCellController(viewModel: .init(subscriptionLink: "www.any-url.com", links: [])))]
    }

    private func listWithContent(_ appStub: [AppViewModel]) -> [CellController] {
        appStub.map { app in
            CellController(id: UUID(), AppCellController(viewModel: app, selection: {}))
        }
    }

    private func appStub() -> [AppViewModel] {
        [
            AppViewModel(name: "V2Box", storeUrl: URL(string: "www.any-url.com")!, appUrl: URL(string:"V2Box://app")!, image: UIImage.make(withColor: .red).pngData()!, actionText: "Open"),
            AppViewModel(name: "V2ray", storeUrl: URL(string: "www.any-url.com")!, appUrl: URL(string:"V2ray://app")!, image: UIImage.make(withColor: .blue).pngData()!, actionText: "Open")
        ]
    }
}
