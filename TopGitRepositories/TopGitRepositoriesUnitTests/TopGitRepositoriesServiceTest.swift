//
//  TopGitRepositoriesServiceTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/26/22.
//

import XCTest

protocol HTTPClient {
    func perform(urlRequest: URLRequest)
}

class TopGitRepositoriesService {
  
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(urlRequest: URLRequest) {
        client.perform(urlRequest: urlRequest)
    }
}

class TopGitRepositoriesServiceTest: XCTestCase {
    
    func test_fetch_requestDataFromClient() throws {
        
        //arrange
        let client = HttpClientSpy()
        let sut = TopGitRepositoriesService(client: client)
        let urlReq = URLRequest(url: URL(string: "https://sada-pay.com")!)
        
        //act
        sut.fetch(urlRequest: urlReq)
        
        //assert
        XCTAssert(client.requestedURLs.count == 1)
    }
    
    //MARK: - Helpers
    
    class HttpClientSpy: HTTPClient {
        
        var requestedURLs = [URLRequest]()
        
        
        func perform(urlRequest: URLRequest) {
            self.requestedURLs.append(urlRequest)
        }
        
    }
    
}
