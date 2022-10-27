//
//  TopGitRepositoriesListViewModelTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import XCTest
@testable import TopGitRepositories

class Reactive<T> {
    typealias Listner = (T) -> Void
    var listner: [Listner?] = [Listner?]()
    
    var value: T {
        didSet {
            for l in listner {
                l?(value)
            }
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(listner: Listner?) {
        self.listner.append(listner)
        listner?(value)
    }
}


class TopGitRepositoriesListViewModel {
    
    let service: TopGitRepositoryServiceProtocol
    
    var isLoading = Reactive(false)
    
    init(service: TopGitRepositoryServiceProtocol) {
        self.service = service
    }
    
    func viewLoaded() {
        fetchTopRepositories()
    }
    
    private func fetchTopRepositories() {
        isLoading.value = true
        let request = TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest()
        service.fetch(urlRequest: request) { _ in
        }
    }
}

class TopGitRepositoriesListViewModelTest: XCTestCase {


    func test_viewLoaded_requestDataFromServiceAndStartsLoader() throws {
        
        let service = TopGitRepositoryServiceSpy()
        let sut = TopGitRepositoriesListViewModel(service: service)
        var isLoading = false
        
        sut.isLoading.bind { val in isLoading = val }
        sut.viewLoaded()
        
        XCTAssertEqual(service.fetchRequests.count, 1)
        XCTAssertTrue(isLoading)
    }
    
    
    //MARK: - Helpers
    
    class TopGitRepositoryServiceSpy: TopGitRepositoryServiceProtocol {
        
        var fetchRequests = [URLRequest: (Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void]()
        
        func fetch(urlRequest: URLRequest, completion: @escaping (Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void) {
            fetchRequests[urlRequest] = completion
        }
    
    }

}
