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
        let viewModelSpy = TopGitRepositoriesListViewModelMock()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)
        let _ = sut.view
        XCTAssertEqual(viewModelSpy.viewLoadedCalled, 1)
    }
    
    func test_viewDidLoad_bindsToViewModel() throws {
        let viewModelSpy = TopGitRepositoriesListViewModelMock()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)

        let _ = sut.view
        
        XCTAssertEqual(viewModelSpy.errMsg.listner.count, 1)
        XCTAssertEqual(viewModelSpy.reloadListOfRepositories.listner.count, 1)
        XCTAssertEqual(viewModelSpy.notConnectedToInternet.listner.count, 1)
        XCTAssertEqual(viewModelSpy.isLoading.listner.count, 1)

    }
    
    func test_viewType_shouldBeTopGitRespositoryListView() throws {
        let viewModelSpy = TopGitRepositoriesListViewModelMock()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)

        let _ = sut.view
        
        XCTAssertNotNil(sut.view as? TopGitRepositoriesListView)
    }
    
    func test_reloadListOfRepositories_displaysListOfRepos() throws {
        let viewModelSpy = TopGitRepositoriesListViewModelMock()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)

        let _ = sut.view

        XCTAssertEqual(sut.rootView.tableView.dataSource?.numberOfSections?(in: sut.rootView.tableView), 1)
        XCTAssertEqual(sut.rootView.tableView.numberOfRows(inSection: 0), 10)

        viewModelSpy.numberOfReposToReturn = 20
        viewModelSpy.reloadListOfRepositories.value = ()// this will call tableview.reload method to reload the list and display
       
        let expectation = expectation(description: "Test")
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(sut.rootView.tableView.numberOfRows(inSection: 0), 20)
    }
    
    func test_reloadListOfRepositories_displaysCellWithCorrectInfo() throws {
        let viewModelSpy = TopGitRepositoriesListViewModelMock()
        let sut = TopGitRepositoriesListViewController(viewModel: viewModelSpy)

        let _ = sut.view

        viewModelSpy.reloadListOfRepositories.value = ()

        let cell = sut.rootView.tableView.dataSource?.tableView(sut.rootView.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? GitRepositoryListCell
        
        XCTAssertEqual(cell?.labelLanguage.text, "swift")
        XCTAssertEqual(cell?.labelStarCount.text, "5")
        XCTAssertEqual(cell?.labelRepoName.text, "swift-101")
        XCTAssertEqual(cell?.labelOwner.text, "Haseeb")
    }
    

    //MARK: - Helpers
    class TopGitRepositoriesListViewModelMock: TopGitRepositoriesListViewModelProtocol {
       
        var viewLoadedCalled = 0
        var refreshListCalled = 0
        var numberOfReposToReturn = 10
        
        var numberOfRepositories: Int {
            return numberOfReposToReturn
        }
        
        var isLoading: Reactive<Bool> = .init(false)
        
        var errMsg: Reactive<String> = .init(nil)
        
        var reloadListOfRepositories: Reactive<Void> = .init(nil)
        
        var notConnectedToInternet: Reactive<Bool> = .init(false)
         
        var title: String {
            return "Trending"
        }
        
        func getRepository(at index: Int) -> GitRepositoryViewModel? {
            return GitRepositoryViewModel(id: 1, userName: "Haseeb", avtarURL: nil, repoName: "swift-101", repoDescription: "test swift package", starsCount: 5, language: "swift")
            
        }
        
        func viewLoaded() {
            viewLoadedCalled += 1
        }
        
        func refreshList() {
            refreshListCalled += 1
        }
        
        
    }

}
