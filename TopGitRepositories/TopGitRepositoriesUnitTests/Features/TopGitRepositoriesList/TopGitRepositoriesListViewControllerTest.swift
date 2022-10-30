//
//  TopGitRepositoriesListViewControllerTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/30/22.
//

import XCTest
@testable import TopGitRepositories

class TopGitRepositoriesListViewControllerTest: XCTestCase {


    func test_viewDidLoad_notifiesViewModel() throws {
        let viewModelSpy = TopGitRepositoriesListViewModelSpy()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)
        let _ = sut.view
        XCTAssertEqual(viewModelSpy.viewLoadedCalled, 1)
    }
    
    func test_viewDidLoad_bindsToViewModel() throws {
        let viewModelSpy = TopGitRepositoriesListViewModelSpy()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)

        let _ = sut.view
        
        XCTAssertEqual(viewModelSpy.errMsg.listner.count, 1)
        XCTAssertEqual(viewModelSpy.reloadListOfRepositories.listner.count, 1)
        XCTAssertEqual(viewModelSpy.notConnectedToInternet.listner.count, 1)
        XCTAssertEqual(viewModelSpy.isLoading.listner.count, 1)

    }
    
    
    
    //MARK: - Helpers
    class TopGitRepositoriesListViewModelSpy: TopGitRepositoriesListViewModelProtocol {
       
        var viewLoadedCalled = 0
        var refreshListCalled = 0
        
        var numberOfRepositories: Int {
            return 10
        }
        
        var isLoading: Reactive<Bool> = .init(false)
        
        var errMsg: Reactive<String> = .init(nil)
        
        var reloadListOfRepositories: Reactive<Void> = .init(nil)
        
        var notConnectedToInternet: Reactive<Bool> = .init(false)
         
        var title: String {
            return "Trending"
        }
        
        func getRepository(at index: Int) -> GitRepositoryViewModel? {
            return nil
        }
        
        func viewLoaded() {
            viewLoadedCalled += 1
        }
        
        func refreshList() {
            refreshListCalled += 1
        }
        
        
    }

}
