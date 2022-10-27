//
//  TopGitRepositoriesListViewController.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import UIKit

class TopGitRepositoriesListViewController: UIViewController {
    
    init() {
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
    }
    
}
