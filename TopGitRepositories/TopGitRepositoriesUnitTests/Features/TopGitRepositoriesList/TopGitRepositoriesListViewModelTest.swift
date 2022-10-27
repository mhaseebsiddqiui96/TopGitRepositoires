//
//  TopGitRepositoriesListViewModelTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import XCTest
@testable import TopGitRepositories

class Reactive<T> {
    typealias Listner = (T?) -> Void
    var listner: [Listner?] = [Listner?]()
    
    var value: T? {
        didSet {
            for l in listner {
                l?(value)
            }
        }
    }
    
    init(_ value: T?) {
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

    private func fetchTopRepositories() {
        
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
    
}

extension Error {
    var isNoInternetError: Bool {
        let code = URLError.Code(rawValue: (self as NSError).code)
        switch code {
        case .notConnectedToInternet: return true
        default: return false
        }
    }
}

class TopGitRepositoriesListViewModelTest: XCTestCase {

    func test_viewModelState_onInit() throws {
        let service = TopGitRepositoryServiceSpy()
        let sut = TopGitRepositoriesListViewModel(service: service)
        
        XCTAssertEqual(sut.isLoading.value, false)
        XCTAssertEqual(sut.numberOfRepositories, 0)
        XCTAssertEqual(service.fetchRequests.count, 0)
        XCTAssertNil(sut.errMsg.value)
    }

    func test_viewModelState_onViewLoaded() throws {
        
        let service = TopGitRepositoryServiceSpy()
        let sut = TopGitRepositoriesListViewModel(service: service)
        var isLoading = false
        
        sut.isLoading.bind { val in isLoading = val ?? false}
        
        sut.viewLoaded()
        
        XCTAssertNotNil(service.fetchRequests[TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest()])
        XCTAssertTrue(isLoading)

    }
    
    func test_viewModelState_onViewLoaded_getsErrorFromService() throws {
        
        let service = TopGitRepositoryServiceSpy()
        let sut = TopGitRepositoriesListViewModel(service: service)
        
        var isLoading = true
        var errMsg: String?
        
        sut.isLoading.bind { val in isLoading = val ?? true}
        sut.errMsg.bind { msg in errMsg = msg }
        
        sut.viewLoaded()
        
        service.completesWithError(urlRequest: TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest(), error: .invalidData)
        
        XCTAssertFalse(isLoading)
        XCTAssertNotNil(errMsg)
    }
    
    func test_viewModelState_onViewLoaded_getsNoInternetErrorFromService() throws {
        
        let service = TopGitRepositoryServiceSpy()
        let sut = TopGitRepositoriesListViewModel(service: service)
        
        var isLoading = true
        var noInternet = false
        
        sut.isLoading.bind { val in isLoading = val ?? true}
        sut.notConnectedToInternet.bind { val in noInternet = val ?? true }
        
        sut.viewLoaded()
        
        service.completesWithError(urlRequest: TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest(), error: .clientError(error: NSError(domain: "no intenet", code: URLError.Code.notConnectedToInternet.rawValue)))
        
        XCTAssertFalse(isLoading)
        XCTAssertNotNil(noInternet)
    }
    
    func test_viewModelState_onViewLoaded_getsSuccessFromService() throws {
        
        let service = TopGitRepositoryServiceSpy()
        let sut = TopGitRepositoriesListViewModel(service: service)
        
        var isLoading = true
        var reloadListCalled: Bool = false
        
        sut.isLoading.bind { val in isLoading = val ?? true}
        sut.reloadListOfRepositories.bind { val in reloadListCalled = val != nil }
        
        sut.viewLoaded()
        
        let models = [GitRepositoryItem(id: 1, language: "lan", name: "name", starsCount: 5, description: "desc", owner: nil)]
        service.completesWithSuccess(urlRequest: TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest(), models: models)
        
        XCTAssertFalse(isLoading)
        XCTAssertEqual(sut.numberOfRepositories, 1)
        XCTAssertEqual(sut.getRepository(at: 0), models[0])
        XCTAssertTrue(reloadListCalled)
    }
    
    
    
    
    //MARK: - Helpers
    
    class TopGitRepositoryServiceSpy: TopGitRepositoryServiceProtocol {
        
        var fetchRequests = [URLRequest: (Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void]()
        
        func fetch(urlRequest: URLRequest, completion: @escaping (Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void) {
            fetchRequests[urlRequest] = completion
        }
        
        func completesWithError(urlRequest: URLRequest, error: GitRepositoryServiceError) {
            fetchRequests[urlRequest]?(.failure(error))
        }
        
        func completesWithSuccess(urlRequest: URLRequest, models: [GitRepositoryItem]) {
            fetchRequests[urlRequest]?(.success(models))
        }
    
    }

}
