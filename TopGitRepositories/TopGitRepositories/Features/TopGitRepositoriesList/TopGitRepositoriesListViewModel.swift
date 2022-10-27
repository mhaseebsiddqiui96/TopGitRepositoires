//
//  TopGitRepositoriesListViewModel.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import Foundation

protocol TopGitRepositoriesListViewModelProtocol {
    
    // outputs
    var numberOfRepositories: Int {get}
    var isLoading: Reactive<Bool> {get}
    var errMsg: Reactive<String> {get}
    var reloadListOfRepositories: Reactive<Void> {get}
    var notConnectedToInternet: Reactive<Bool> { get }
    func getRepository(at index: Int) -> GitRepositoryItem?
    
    // inputs
    func viewLoaded()
    func refreshList()
}

class TopGitRepositoriesListViewModel: TopGitRepositoriesListViewModelProtocol {
    
    let service: TopGitRepositoryServiceProtocol
    
    var isLoading = Reactive(false)
    var errMsg = Reactive<String>(nil)
    var reloadListOfRepositories = Reactive<Void>(())
    var notConnectedToInternet = Reactive(false)
    
    var numberOfRepositories: Int {
        return respositories.count
    }
    
    private var respositories: [GitRepositoryItem] = [] {
        didSet {
            reloadListOfRepositories.value = ()
        }
    }
    
    init(service: TopGitRepositoryServiceProtocol) {
        self.service = service
    }
    
    func viewLoaded() {
        fetchTopRepositories()
    }

    func fetchTopRepositories() {
        
        isLoading.value = true
        let request = TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest()
        
        service.fetch(urlRequest: request) {[weak self] result in
            guard let self = self else {return}
            self.isLoading.value = false
            self.handleGetRepositoryResult(result)
        }
    }
    
    
    fileprivate func handleGetRepositoryResult(_ result: Result<[GitRepositoryItem], GitRepositoryServiceError>) {
        
        switch result {
        case .success(let repos):
            respositories = repos
        case .failure(let err):
            switch err {
            case .invalidData: errMsg.value = err.localizedDescription
            case .clientError(let err):
                if err.isNoInternetError {
                    notConnectedToInternet.value = true
                } else {
                    errMsg.value = err.localizedDescription
                }
            }
        }
    }
    
    func getRepository(at index: Int) -> GitRepositoryItem? {
        if index < respositories.count {
            return respositories[index]
        }
        return nil
    }
    
    func refreshList() {
        fetchTopRepositories()
    }
}
