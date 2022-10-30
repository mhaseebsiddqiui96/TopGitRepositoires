//
//  ErrorTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/31/22.
//

import XCTest
@testable import TopGitRepositories

class ErrorTest: XCTestCase {
 
    func test_apiTimeOut() throws {
        //case 1 when not connected to internet
        let noInternetError = NSError(domain: "no-internet", code: URLError.Code.notConnectedToInternet.rawValue)
        XCTAssertTrue(noInternetError.isNoInternetError)
        
        //case 2 when api timedout
        let apiTimeOut = NSError(domain: "api-timeout", code: URLError.Code.timedOut.rawValue)
        XCTAssertTrue(apiTimeOut.isNoInternetError)
    }
    
}
