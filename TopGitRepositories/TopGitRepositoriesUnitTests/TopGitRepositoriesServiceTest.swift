//
//  TopGitRepositoriesServiceTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/26/22.
//

import XCTest
@testable import TopGitRepositories

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
        let expectedResult: GitRepositoryServiceError = .clientError(error: NSError(domain: "any-domain", code: 400, userInfo: [:]))
        var receivedResult: GitRepositoryServiceError?

        sut.fetch(urlRequest: urlReq, completion: { result in
            switch result {
            case .failure(let err):
                receivedResult = err
            case .success:
                XCTFail("Expected Failure but fount success instead!")
            }
        })
        
        client.completesWithError(for: urlReq, error: NSError(domain: "any-domain", code: 400, userInfo: [:]))
        //assert
        switch (receivedResult, expectedResult) {
        case (.clientError(let receivedError as NSError), .clientError(let expectedError as NSError)):
            XCTAssert(receivedError.code == expectedError.code, "\(expectedError) \(receivedError.code)")
        default:
            XCTFail("Expected failure but got something else")
        }

    }
    
    
    func test_fetch_deliversErrorOnNon200ClientResponse() throws {
        
        let (sut, client) = makeSUT()

        [300, 400, 401, 500].forEach { code in
            
            let urlReq = URLRequest(url: URL(string: "https://sada-pay.com")!)
            let expectedResult: GitRepositoryServiceError = .invalidData
            var receivedResult: GitRepositoryServiceError?

            sut.fetch(urlRequest: urlReq, completion: { result in
                switch result {
                case .failure(let err):
                    receivedResult = err
                case .success:
                    XCTFail("Expected Failure but fount success instead!")
                }
            })
            
            client.completesWithSuccess(for: urlReq, code: code, data: Data())
            //assert
            switch (receivedResult, expectedResult) {
            case (.invalidData, .invalidData):
                XCTAssert(true)
            default:
                XCTFail("Expected failure but got something else")
            }

        }
                
    }
    
    func test_fetch_deliversErrorOn200WithInvalidJSON() throws {
        
        let (sut, client) = makeSUT()

        let urlReq = URLRequest(url: URL(string: "https://sada-pay.com")!)
        let expectedResult: GitRepositoryServiceError = .invalidData
        var receivedResult: GitRepositoryServiceError?

        sut.fetch(urlRequest: urlReq, completion: { result in
            switch result {
            case .failure(let err):
                receivedResult = err
            case .success:
                XCTFail("Expected Failure but fount success instead!")
            }
        })
        
        client.completesWithSuccess(for: urlReq, code: 200, data: Data("invalid".utf8))
        //assert
        switch (receivedResult, expectedResult) {
        case (.invalidData, .invalidData):
            XCTAssert(true)
        default:
            XCTFail("Expected failure but got something else")
        }
    }
    
    func test_fetch_deliversListOfRepositoriesOn200WithValidJSON() throws {
        
        let (sut, client) = makeSUT()

        let urlReq = URLRequest(url: URL(string: "https://sada-pay.com")!)
        
        let expectedResult = [
            GitRepositoryItem(id: 1, language: "lan", name: "name", starsCount: 5, description: "desc", owner: nil),
            GitRepositoryItem(id: 2, language: "lan", name: "name", starsCount: 5, description: "desc", owner: GitRepositoryOwner(login: "login", avatarURL: URL(string: "https://some-url.com"))),

        ]
        
        var receivedResult = [GitRepositoryItem]()

        sut.fetch(urlRequest: urlReq, completion: { result in
            switch result {
            case .failure:
                XCTFail("Expected Success but found failure instead!")
            case .success(let repos):
                receivedResult = repos
            }
        })
        
        let json = ["items": makeJSON(expectedResult)]
        let validResultListJSON = try! JSONSerialization.data(withJSONObject: json)
        client.completesWithSuccess(for: urlReq, code: 200, data: validResultListJSON)
        //assert
        XCTAssert(receivedResult == expectedResult, "received result: \(receivedResult)")
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
    
    func makeJSON(_ models: [GitRepositoryItem]) -> [[String: Any]] {
        var resultant = [[String: Any]]()
        
        for model in models {

            var ownerJSON: [String: Any]?
            if let owner = model.owner {
                ownerJSON = [
                    "login": owner.login,
                    "avatar_url": owner.avatarURL?.absoluteString,
                ]
            }
            
            
            let json: [String: Any] = [
                "id": model.id,
                "full_name": model.name,
                "description": model.description,
                "language": model.language,
                "stargazers_count": model.starsCount,
                "owner": ownerJSON
            ]
            
            resultant.append(json)
        }
        
        return resultant
    }
    
    
}
