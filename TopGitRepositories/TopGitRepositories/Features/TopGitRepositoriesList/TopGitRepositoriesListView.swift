//
//  TopGitRepositoriesListView.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit

class TopGitRepositoriesListView: UIView {
    
    let viewModel: TopGitRepositoriesListViewModelProtocol

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GitRepositoryListCell.self, forCellReuseIdentifier: "\(GitRepositoryListCell.self)")
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
   
    init(viewModel: TopGitRepositoriesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        initialSetup()
        bindings()
    }
    
    fileprivate func initialSetup() {
        backgroundColor = .white
        addRepoTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.canShimmer = true
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    }
    
    private func bindings() {
        bindToReloadList()
        bindToisLoading()
        bindToNoInternet()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRepoTableView() {
        addSubviewAndPinEdges(tableView)
    }
    
    
    fileprivate func bindToNoInternet() {
        viewModel.notConnectedToInternet.bind {[weak self] notConnected in
            if let notConnected = notConnected, notConnected {
                DispatchQueue.main.async {
                    self?.showNoInternetView {[weak self] in
                        self?.viewModel.viewLoaded()
                        self?.hideNoInternetView()
                    }
                }
            }
        }
    }
    
    fileprivate func bindToisLoading() {
        viewModel.isLoading.bind {[weak self] isLoading in
            if let isloading = isLoading, isloading {
                DispatchQueue.main.async {
                    self?.handleTableViewLoadingState()
                }
            } else {
                DispatchQueue.main.async {
                    self?.handleTableViewNotLoadingState()
                }
            }
            
        }
    }
    
    fileprivate func handleTableViewLoadingState() {
        self.tableView.displayGradientAnimation()
    }
    
    fileprivate func handleTableViewNotLoadingState() {
        self.refreshControl.endRefreshing()
        self.tableView.canShimmer = true
        self.tableView.hideGradientAnimation()
    }
    
    fileprivate func bindToReloadList() {
        viewModel.reloadListOfRepositories.bind {[weak self] val in
            if val != nil { DispatchQueue.main.async { self?.tableView.reloadData() }}
        }
    }
    
    @objc func refreshList() {
        // doing this because when I pull down to refresh it was giving me some logs of unable to satisfy constaints simulataniously may be it was happening because of this skeleton view so stop this while pull down
        tableView.canShimmer = false
        viewModel.refreshList()
    }
}

extension TopGitRepositoriesListView: Skeletonable, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRepositories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(GitRepositoryListCell.self)", for: indexPath) as? GitRepositoryListCell else { return UITableViewCell() }
        if let viewModel = viewModel.getRepository(at: indexPath.row) {
            cell.populate(with: viewModel)
        }
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> String {
        return "\(GitRepositoryListCell.self)"
    }

}

