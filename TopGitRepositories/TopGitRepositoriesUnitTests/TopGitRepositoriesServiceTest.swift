//
//  TopGitRepositoriesServiceTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/26/22.
//

import XCTest

protocol HTTPClient {
    func perform(urlRequest: URLRequest, completion: @escaping(Error) -> Void)
}

class TopGitRepositoriesService {
  
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(urlRequest: URLRequest, completion: @escaping(Error) -> Void) {
        client.perform(urlRequest: urlRequest, completion: { err in
            completion(err)
        })
    }
}

class TopGitRepositoriesServiceTest: XCTestCase {
    
    func test_fetch_requestDataFromClient() throws {
        
        //arrange
        let (sut, client) = makeSUT()
        let url = URL(string: "https://sada-pay.com")!
        let urlReq = URLRequest(url: url)
        
        //act
        sut.fetch(urlRequest: urlReq, completion: {_ in})
        
        //assert
        XCTAssert(client.requestedURLs.count == 1)
        XCTAssert(client.requestedURLs[urlReq] != nil)
    }
    
    func test_fetch_deliversErrorOnClientError() throws {
        
        let (sut, client) = makeSUT()

        let urlReq = URLRequest(url: URL(string: "https://sada-pay.com")!)
        let expectedResult = NSError(domain: "some-domain", code: 400)
        var receivedResult: NSError?

        sut.fetch(urlRequest: urlReq, completion: { err in
            receivedResult = err as NSError
        })
        
        client.completesWithError(for: urlReq, error: expectedResult)
        //assert
        XCTAssert(receivedResult == expectedResult)
    }
    
    //MARK: - Helpers
    
    class HttpClientSpy: HTTPClient {
        
        var requestedURLs = [URLRequest: (Error) -> Void]()
        
        
        func perform(urlRequest: URLRequest, completion: @escaping(Error) -> Void) {
            self.requestedURLs[urlRequest] = completion
        }
        
        func completesWithError(for request: URLRequest, error: Error) {
            self.requestedURLs[request]?(error)
        }
        
    }
    
    func makeSUT() -> (TopGitRepositoriesService, HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = TopGitRepositoriesService(client: client)
        return (sut, client)
    }
    
}
