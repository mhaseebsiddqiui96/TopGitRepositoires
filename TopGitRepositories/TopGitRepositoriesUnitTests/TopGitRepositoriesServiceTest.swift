//
//  TopGitRepositoriesServiceTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/26/22.
//

import XCTest

protocol HTTPClient {
    
    typealias HttpClientResult = Result<(data: Data, response: HTTPURLResponse), Error>
    
    func perform(urlRequest: URLRequest, completion: @escaping(HttpClientResult) -> Void)
}

class TopGitRepositoriesService {
  
    let client: HTTPClient
    
    enum Error: Swift.Error {
        case invalidData
        case internetConnectivity
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(urlRequest: URLRequest, completion: @escaping(Error) -> Void) {
        client.perform(urlRequest: urlRequest, completion: { result in
            switch result {
            case .success(let response):
                completion(.invalidData)
            case .failure:
                completion(.internetConnectivity)
            }
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
        let expectedResult = TopGitRepositoriesService.Error.internetConnectivity
        var receivedResult: TopGitRepositoriesService.Error?

        sut.fetch(urlRequest: urlReq, completion: { err in
            receivedResult = err
        })
        
        client.completesWithError(for: urlReq, error: expectedResult)
        //assert
        XCTAssert(receivedResult == expectedResult)
    }
    
    
    func test_fetch_deliversErrorOnNon200ClientResponse() throws {
        
        let (sut, client) = makeSUT()

        [300, 400, 401, 500].forEach { code in
            
            let urlReq = URLRequest(url: URL(string: "https://sada-pay.com")!)
            let expectedResult = TopGitRepositoriesService.Error.invalidData
            var receivedResult: TopGitRepositoriesService.Error?

            sut.fetch(urlRequest: urlReq, completion: { err in
                receivedResult = err
            })
            
            client.completesWithSuccess(for: urlReq, code: code, data: Data())
            //assert
            XCTAssert(receivedResult == expectedResult)

        }
                
    }
    
    //MARK: - Helpers
    
    class HttpClientSpy: HTTPClient {
        
        var requestedURLs = [URLRequest: (HttpClientResult) -> Void]()
        
        
        func perform(urlRequest: URLRequest, completion: @escaping(HttpClientResult) -> Void) {
            self.requestedURLs[urlRequest] = completion
        }
        
        func completesWithError(for request: URLRequest, error: Error) {
            self.requestedURLs[request]?(.failure(error))
        }
        
        func completesWithSuccess(for request: URLRequest, code: Int, data: Data) {
            let httpURLResponse = HTTPURLResponse(url: request.url!, statusCode: code, httpVersion: nil, headerFields: nil)!
            self.requestedURLs[request]?(.success((data, httpURLResponse)))

        }
        
    }
    
    func makeSUT() -> (TopGitRepositoriesService, HttpClientSpy) {
        let client = HttpClientSpy()
        let sut = TopGitRepositoriesService(client: client)
        return (sut, client)
    }
    
}
