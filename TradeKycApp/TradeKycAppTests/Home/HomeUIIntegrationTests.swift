//
//  HomeUIIntegrationTests.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/6/24.
//

import XCTest
import TradeKyc
import TradeKycPresentation
import TradeKyciOS
import TradeKycApp

final class HomeUIIntegrationTests: XCTestCase {

    func test_loadingIndicator_isVisibleWhileLoadingData() {
        let (sut, service) = makeSUT()
        sut.simulateAppearance()

        let anyAdmin = Admin(username: "any", password: "any")
        let anyUser = User(username: "any", subscriptionURL: "any", links: [])
        let anyToken = "any token"

        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "expect to show loading indicator while requesting data")
        service.completeGetAdmin(with: MarzbanServiceError.invalidData)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "expect to hide loading indicator while receiving error ")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "expect to show loading indicator while requesting data")
        service.complete(with: anyAdmin)
        service.completeGetToken(with: MarzbanServiceError.invalidData)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "expect to hide loading indicator while receiving error ")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "expect to show loading indicator while requesting data")
        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: anyUser)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "expect to hide loading indicator while receiving results")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "expect to show loading indicator while requesting data")
        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: .invalidData)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "expect to hide loading indicator while receiving error ")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "expect to show loading indicator while requesting data")
        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: .notFound)
        service.completeAddUser(with: .invalidData)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "expect to hide loading indicator while receiving error ")
        
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(sut.isShowingLoadingIndicator, true, "expect to show loading indicator while requesting data")
        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: .notFound)
        service.completeAddUser(with: anyUser)
        XCTAssertEqual(sut.isShowingLoadingIndicator, false, "expect to hide loading indicator while receiving results")

    }
    
    func test_requestDataCompletion_rendersSuccessfullyLoadedData() {
        let (sut, service) = makeSUT(apps: appStub())
        sut.simulateAppearance()
        
        let anyAdmin = Admin(username: "any", password: "any")
        let anyUser = User(username: "any", subscriptionURL: "any", links: [])
        let anyToken = "any token"

        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: anyUser)

        assertThat(sut, isRendering: HomeViewModel(user: anyUser), with: appStub())
    }

    func test_requestData_onErrorNotRenderCells() {
        let (sut, service) = makeSUT(apps: appStub())
        sut.simulateAppearance()
        service.completeGetAdmin(with: MarzbanServiceError.invalidData)
        assertThat(sut, isRendering: nil, with: [])
        
        let anyAdmin = Admin(username: "any", password: "any")
        let anyToken = "any token"

        sut.simulateUserInitiatedReload()
        service.complete(with: anyAdmin)
        service.completeGetToken(with: .invalidData)
        assertThat(sut, isRendering: nil, with: [])
        
        sut.simulateUserInitiatedReload()
        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: .invalidData)
        assertThat(sut, isRendering: nil, with: [])
        
        sut.simulateUserInitiatedReload()
        service.complete(with: anyAdmin)
        service.complete(with: anyToken)
        service.completeGetUser(with: .notFound)
        service.completeAddUser(with: .invalidData)
        assertThat(sut, isRendering: nil, with: [])
    }

    private func makeSUT(apps: [AppViewModel] = [], file: StaticString = #filePath, line: UInt = #line) -> (sut: HomeViewController, service: ServiceSpy) {
        let serviceSpy = ServiceSpy()
        let controller = HomeUIComposer.homeComposedWith(tradeKycService: serviceSpy, marzbanService: serviceSpy, apps: apps, onAppSelection: {_,_ in })
        trackForMemoryLeaks(serviceSpy, file: file, line: line)
        trackForMemoryLeaks(controller, file: file, line: line)
        return (controller, serviceSpy)
    }

    private func appStub() -> [AppViewModel] {
        [
            AppViewModel(name: "V2Box", storeUrl: URL(string: "www.any-url.com")!, appUrl: URL(string:"V2Box://app")!, image: UIImage.make(withColor: .red).pngData()!, actionText: "Open"),
            AppViewModel(name: "V2ray", storeUrl: URL(string: "www.any-url.com")!, appUrl: URL(string:"V2ray://app")!, image: UIImage.make(withColor: .blue).pngData()!, actionText: "Open")
        ]
    }

}
