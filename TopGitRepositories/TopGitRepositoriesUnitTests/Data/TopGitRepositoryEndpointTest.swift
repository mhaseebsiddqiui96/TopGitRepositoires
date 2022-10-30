//
//  TopGitRepositoryEndpointTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import XCTest
@testable import TopGitRepositories

class TopGitRepositoryEndpointTest: XCTestCase {

    func test_topGitRepo_endpointURL() throws {
        let endPoint = TopGitRepositoryEndpoint.getTopGitRepos.asURLRequest()
        let url = endPoint.url
        
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "https")
        XCTAssertEqual(url?.host, "api.github.com")
        XCTAssertEqual(url?.path, "/search/repositories")
    }

}
