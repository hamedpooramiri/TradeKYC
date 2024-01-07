//
//  HomeViewController.swift
//  TradeKyciOS
//
//  Created by hamedpouramiri on 1/4/24.
//

import UIKit
import TradeKycPresentation

public final class HomeViewController: UITableViewController, HomePresenterErrorView, HomePresenterLoadingView {

    private(set) public var errorView = ErrorView()
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
    }()
    
    public var presenter: HomePresenterInput?
    private var onViewIsAppearing: ((HomeViewController) -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        onViewIsAppearing = { vc in
            vc.requestData()
            vc.onViewIsAppearing = nil
        }
        configureTableView()
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        onViewIsAppearing?(self)
    }

    private func configureTableView() {
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        tableView.tableHeaderView = errorView.makeContainer()

        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
    }

    private func requestData() {
        presenter?.requestData(withDeviceID:  UIDevice.current.identifierForVendor?.uuidString)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }

    @IBAction private func onRefresh() {
        requestData()
    }
    
    // MARK: Tableview delegate
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dl = cellController(at: indexPath)?.delegate
        dl?.tableView?(tableView, didSelectRowAt: indexPath)
    }

    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }

    // MARK: Incoming Actions

    public func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        
        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot)
        }
    }

    public func display(error: String) {
        errorView.message = error
    }

    public func display(isLoading: Bool) {
        if isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }

}
