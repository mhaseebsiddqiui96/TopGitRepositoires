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
    }
    
    private func bindings() {
        viewModel.reloadListOfRepositories.bind {[weak self] val in
            if val != nil { DispatchQueue.main.async { self?.tableView.reloadData() }}
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addRepoTableView() {
        addSubviewAndPinEdges(tableView)
    }
    
}

extension TopGitRepositoriesListView: UITableViewDataSource, UITableViewDelegate {
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
}

