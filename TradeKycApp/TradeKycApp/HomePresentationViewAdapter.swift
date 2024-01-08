//
//  HomePresentationViewAdapter.swift
//  TradeKycApp
//
//  Created by hamedpouramiri on 1/7/24.
//
import TradeKycPresentation
import TradeKyciOS

final class HomePresentationViewAdapter: HomePresenterView {

    private weak var viewController: HomeViewController?
    private var apps: [AppViewModel]
    private var onAppSelection: (AppViewModel, HomeViewModel) -> Void

    init(viewController: HomeViewController, apps: [AppViewModel], onAppSelection: @escaping (AppViewModel, HomeViewModel) -> Void) {
        self.viewController = viewController
        self.apps = apps
        self.onAppSelection = onAppSelection
    }

    func display(viewModel: HomeViewModel) {
        let qrCodeCellController = CellController(id: UUID(), QRCodeCellController(viewModel: viewModel))
        let appsCellController = apps.map { [weak self, viewModel] app in
            CellController(id: UUID(), AppCellController(viewModel: app, selection: {
                self?.onAppSelection(app, viewModel)
            }))
        }
        viewController?.display([qrCodeCellController], appsCellController)
    }

}
