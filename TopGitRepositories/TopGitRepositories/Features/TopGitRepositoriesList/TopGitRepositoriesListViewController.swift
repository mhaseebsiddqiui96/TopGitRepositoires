//
//  TopGitRepositoriesListViewController.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit

class TopGitRepositoriesListViewController: UIViewController {
    
    let viewModel: TopGitRepositoriesListViewModelProtocol
    
    init(viewModel: TopGitRepositoriesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = TopGitRepositoriesListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLoaded()
        bindToViewModel()
    }
    
    
    func bindToViewModel() {
     
        viewModel.notConnectedToInternet.bind { _ in
            
        }
        
        viewModel.reloadListOfRepositories.bind { _ in
            
        }
        
        viewModel.errMsg.bind { _ in
            
        }
        
        viewModel.isLoading.bind { _ in
            
        }
    }
    
}
