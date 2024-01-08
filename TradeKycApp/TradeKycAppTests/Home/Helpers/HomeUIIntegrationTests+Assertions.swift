//
//  HomeUIIntegrationTests+Assertions.swift
//  TradeKycAppTests
//
//  Created by hamedpouramiri on 1/7/24.
//

import XCTest
import TradeKycPresentation
import TradeKyciOS

extension HomeUIIntegrationTests {
    
    func assertThat(_ sut: HomeViewController, isRendering viewModel: HomeViewModel?, with apps: [AppViewModel], file: StaticString = #filePath, line: UInt = #line) {
        sut.view.enforceLayoutCycle()
        
        guard sut.numberOfRenderedAppCells() == apps.count else {
            return XCTFail("Expected \(apps.count) Apps, got \(sut.numberOfRenderedAppCells()) instead.", file: file, line: line)
        }
        
        guard sut.numberOfRenderedQrCodeCells() == ((viewModel != nil) ? 1 : 0) else {
            return XCTFail("Expected \(apps.count) Apps, got \(sut.numberOfRenderedAppCells()) instead.", file: file, line: line)
        }

        apps.enumerated().forEach { index, app in
            assertThat(sut, hasViewConfiguredFor: app, at: index, file: file, line: line)
        }
        
        executeRunLoopToCleanUpReferences()
    }
    
    func assertThat(_ sut: HomeViewController, hasViewConfiguredFor app: AppViewModel, at index: Int, file: StaticString = #filePath, line: UInt = #line) {
        let view = sut.appCellView(at: index)
        
        guard let cell = view as? AppCell else {
            return XCTFail("Expected \(AppCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.appNameText, app.name, "Expected app name text to be \(String(describing: app.name)) for AppCell view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.appActionText, app.actionText, "Expected action text to be \(String(describing: app.actionText)) for AppCell view at index (\(index)", file: file, line: line)
    }
    
    private func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }

}
