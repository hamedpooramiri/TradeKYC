//
//  HomePresenterTests.swift
//  TradeKyciOSTests
//
//  Created by hamedpouramiri on 1/4/24.
//

import XCTest
import TradeKyc
import TradeKycPresentation

final class HomePresenterTests: XCTestCase {

    func test_init_doesNotInitiateAnyServices() {
        let (_, service, _) = makeSUT()
        XCTAssertEqual(service.capturedRequests, [])
    }

    func test_requestData_noDeviceID_displayError() {
        let (sut, service, view) = makeSUT()
        sut.requestData(withDeviceID: nil)
        XCTAssertEqual(service.capturedRequests, [])
        XCTAssertEqual(view.capturedResults, [
            .display(error: HomePresenter.NoDeviceIDError().localizedDescription)
        ])
    }

    func test_requestData_failToGetAdmin_displayError() {
        let (sut, service, view) = makeSUT()
        sut.requestData(withDeviceID: "any device ID")
        service.completeGetAdmin(with: anyNSError())
        XCTAssertEqual(service.capturedRequests, [.getAdmin])
        XCTAssertEqual(view.capturedResults, [
            .display(isLoading: true),
            .display(error: anyNSError().localizedDescription),
            .display(isLoading: false)
        ])
    }

    func test_requestData_failToGetToken_displayError() {
        let (sut, service, view) = makeSUT()
        sut.requestData(withDeviceID: "any device ID")
        
        let admin = Admin(username: "any admin", password: "12345")
        service.complete(with: admin)
        
        service.completeGetToken(with: anyMarzbanError())
        
        XCTAssertEqual(service.capturedRequests, [.getAdmin, .getToken(username: admin.username, password: admin.password)])
        XCTAssertEqual(view.capturedResults, [
            .display(isLoading: true),
            .display(error: anyMarzbanError().localizedDescription),
            .display(isLoading: false)
        ])
    }

    func test_requestData_failToGetUser_displayError() {
        let (sut, service, view) = makeSUT()
        let username = "any device ID"
        sut.requestData(withDeviceID: username)
        
        let admin = Admin(username: "any admin", password: "12345")
        service.complete(with: admin)
        
        let anytoken = "any token"
        service.complete(with: anytoken)
        
        service.completeGetUser(with: anyMarzbanError())
    
        XCTAssertEqual(service.capturedRequests, [
            .getAdmin,
            .getToken(username: admin.username, password: admin.password),
            .getUser(username: username, accessToken: anytoken)
        ])
        XCTAssertEqual(view.capturedResults, [
            .display(isLoading: true),
            .display(error: anyMarzbanError().localizedDescription),
            .display(isLoading: false)
        ])
    }

    func test_requestData_failToGetUserWithNotFoundError_addUserSuccessfully() {
        let (sut, service, view) = makeSUT()
        
        let username = "any device ID"
        sut.requestData(withDeviceID: username)
        
        let admin = Admin(username: "any admin", password: "12345")
        service.complete(with: admin)
        
        let anytoken = "any token"
        service.complete(with: anytoken)
        
        service.completeGetUser(with: MarzbanServiceError.notFound)
    
        let user = User(username: username, subscriptionURL: "any link", links: ["a link"])
        service.completeAddUser(with: user)

        XCTAssertEqual(service.capturedRequests, [
            .getAdmin,
            .getToken(username: admin.username, password: admin.password),
            .getUser(username: username, accessToken: anytoken),
            .addUser(username: username, accessToken: anytoken)
        ])

        XCTAssertEqual(view.capturedResults, [
            .display(isLoading: true),
            .display(viewModel: .init(user: user)),
            .display(isLoading: false)
        ])
    }

    func test_requestData_successfullyGetUser_displayData() {
        let (sut, service, view) = makeSUT()
        let username = "any device ID"
        sut.requestData(withDeviceID: username)

        let anyAdmin = Admin(username: "any admin", password: "12345")
        service.complete(with: anyAdmin)
        
        let anytoken = "any token"
        service.complete(with: anytoken)

        let anyUser = User(username: "any user", subscriptionURL: "any link", links: ["a link"])
        service.completeGetUser(with: anyUser)
        
        XCTAssertEqual(service.capturedRequests, [
            .getAdmin,
            .getToken(username: anyAdmin.username, password: anyAdmin.password),
            .getUser(username: username, accessToken: anytoken)
        ])

        XCTAssertEqual(view.capturedResults, [
            .display(isLoading: true),
            .display(viewModel: .init(user: anyUser)),
            .display(isLoading: false)
        ])
    }

    func test_requestData_successfullyAddUser_displayData() {
        let (sut, service, view) = makeSUT()
        let username = "any device ID"
        sut.requestData(withDeviceID: username)

        let anyAdmin = Admin(username: "any admin", password: "12345")
        service.complete(with: anyAdmin)
        
        let anytoken = "any token"
        service.complete(with: anytoken)

        service.completeGetUser(with: .notFound)

        let anyUser = User(username: "any user", subscriptionURL: "any link", links: ["a link"])
        service.completeAddUser(with: anyUser)
        
        XCTAssertEqual(service.capturedRequests, [
            .getAdmin,
            .getToken(username: anyAdmin.username, password: anyAdmin.password),
            .getUser(username: username, accessToken: anytoken),
            .addUser(username: username, accessToken: anytoken)
        ])

        XCTAssertEqual(view.capturedResults, [
            .display(isLoading: true),
            .display(viewModel: .init(user: anyUser)),
            .display(isLoading: false)
        ])
    }

    func test_requestData_notDeliverResultAfterSUTDeallocated() {
        let serviceSpy = ServiceSpy()
        let viewSpy = ViewSpy()
        var sut: HomePresenter? = HomePresenter(tradeKycService: serviceSpy, marzbanService: serviceSpy, errorView: viewSpy, loadingView: viewSpy, view: viewSpy)
        
        sut?.requestData(withDeviceID: "any ID")
        
        sut = nil
        serviceSpy.completeGetAdmin(with: MarzbanServiceError.invalidData)
        
        XCTAssertEqual(viewSpy.capturedResults, [
            .display(isLoading: true)
        ])
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: HomePresenterInput, service: ServiceSpy, view: ViewSpy) {
        let serviceSpy = ServiceSpy()
        let viewSpy = ViewSpy()
        let sut = HomePresenter(tradeKycService: serviceSpy, marzbanService: serviceSpy, errorView: viewSpy, loadingView: viewSpy, view: viewSpy)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(serviceSpy, file: file, line: line)
        trackForMemoryLeaks(viewSpy, file: file, line: line)
        return (sut, serviceSpy, viewSpy)
    }

    private class ServiceSpy: TradeKycServiceProtocol, MarzbanServiceProtocol {

        enum Request: Equatable {
            case getAdmin
            case getToken(username: String, password: String)
            case getUser(username: String, accessToken: String)
            case addUser(username: String, accessToken: String)
        }

        private(set) var capturedRequests = [Request]()
        private(set) var getAdminCapturedCompletions = [(GetAdminResult) -> Void]()
        private(set) var getTokenCapturedCompletions = [(GetTokenResult) -> Void]()
        private(set) var getUserCapturedCompletions = [(GetUserResult) -> Void]()
        private(set) var addUserCapturedCompletions = [(AddUserResult) -> Void]()

        func getAdmin(completion: @escaping (GetAdminResult) -> Void) {
            capturedRequests.append(.getAdmin)
            getAdminCapturedCompletions.append(completion)
        }
        
        func getToken(username: String, password: String, completion: @escaping (GetTokenResult) -> Void) {
            capturedRequests.append(.getToken(username: username, password: password))
            getTokenCapturedCompletions.append(completion)
        }
        
        func getUser(username: String, accessToken: String, completion: @escaping (GetUserResult) -> Void) {
            capturedRequests.append(.getUser(username: username, accessToken: accessToken))
            getUserCapturedCompletions.append(completion)
        }
        
        func addUser(username: String, accessToken: String, completion: @escaping (AddUserResult) -> Void) {
            capturedRequests.append(.addUser(username: username, accessToken: accessToken))
            addUserCapturedCompletions.append(completion)
        }

        func complete(with admin: Admin, at index: Int = 0) {
            getAdminCapturedCompletions[index](.success(admin))
        }
        
        func complete(with token: String, at index: Int = 0) {
            getTokenCapturedCompletions[index](.success(token))
        }

        func completeGetUser(with user: User, at index: Int = 0) {
            getUserCapturedCompletions[index](.success(user))
        }

        func completeAddUser(with user: User, at index: Int = 0) {
            addUserCapturedCompletions[index](.success(user))
        }

        func completeGetAdmin(with error: Error, at index: Int = 0) {
            getAdminCapturedCompletions[index](.failure(error))
        }

        func completeGetToken(with error: MarzbanServiceError, at index: Int = 0) {
            getTokenCapturedCompletions[index](.failure(error))
        }

        func completeGetUser(with error: MarzbanServiceError, at index: Int = 0) {
            getUserCapturedCompletions[index](.failure(error))
        }
        
        func completeAddUser(with error: MarzbanServiceError, at index: Int = 0) {
            addUserCapturedCompletions[index](.failure(error))
        }
    }
    
    private class ViewSpy: HomePresenterView, HomePresenterErrorView, HomePresenterLoadingView {
        
        enum Request: Equatable {
            case display(error: String)
            case display(isLoading: Bool)
            case display(viewModel: HomeViewModel)
        }

        private(set) var capturedResults = [Request]()
        
        func display(error: String) {
            capturedResults.append(.display(error: error))
        }
        
        func display(isLoading: Bool) {
            capturedResults.append(.display(isLoading: isLoading))
        }
        
        func display(viewModel: HomeViewModel) {
            capturedResults.append(.display(viewModel: viewModel))
        }
    }
}
