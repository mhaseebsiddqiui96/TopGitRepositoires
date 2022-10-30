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
        self.title = viewModel.title
        viewModel.viewLoaded()
        bindToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.tableView.isSkeletonable = true
    }
    
    func bindToViewModel() {
        viewModel.errMsg.bind {[weak self] msg in
            if let msg = msg { self?.displayErrorMessage(msg) }
        }
    }
    
    func displayErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: LocalizedStrings.errorTitle.localized, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedStrings.okayTitle.localized, style: .default))
            self.present(alert, animated: true)
        }
        
    }
    
}
