//
//  TopGitRepositoriesListViewController.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit

class TopGitRepositoriesListViewController: UIViewController {
    
    let viewModel: TopGitRepositoriesListViewModelProtocol
    var rootView: TopGitRepositoriesListView { return self.view as! TopGitRepositoriesListView } // I know its a forced unwrap but we can be confident as we have test written for this scenario
    
    init(viewModel: TopGitRepositoriesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = TopGitRepositoriesListView(viewModel: self.viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLoaded()
        bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.tableView.isSkeletonable = true
    }
    
    func bindToViewModel() {
     
        viewModel.notConnectedToInternet.bind { _ in
            
        }
        
        viewModel.errMsg.bind { _ in
            
        }
        
    }
    
}
