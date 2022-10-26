//
//  TopGitRepositoriesServiceTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/26/22.
//

import XCTest
@testable import TopGitRepositories

protocol HTTPClient {
    
    typealias HttpClientResult = Result<(data: Data, response: HTTPURLResponse), Error>
    
    func perform(urlRequest: URLRequest, completion: @escaping(HttpClientResult) -> Void)
}

class TopGitRepositoriesService: TopGitRepositoryServiceProtocol {
  
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func fetch(urlRequest: URLRequest, completion: @escaping(Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void) {
        client.perform(urlRequest: urlRequest, completion: { result in
            switch result {
            case .success(let response):
                completion(GitRepositoryItemMapper.map(response))
            case .failure:
                completion(.failure(.internetConnectivity))
            }
        })
    }
}

struct GitRepositoryItemMapper {
    
    struct Root: Decodable {
        let items: [GitRepositoryDataModel]?
        
        struct GitRepositoryDataModel: Decodable {
            let id: Int
            let name: String?
            let full_name: String?
            let owner: OwnerDataModel?
            let description: String?
            let language: String?
            let stargazers_count: Int?
            
            var repositoyItem: GitRepositoryItem {
                return GitRepositoryItem(id: id, language: language ?? "", name: full_name ?? "", starsCount: stargazers_count ?? 0, description: description ?? "", owner: owner?.ownerItem)
            }

            struct OwnerDataModel : Codable {
                let login : String?
                let avatar_url : String?
                
                var ownerItem: GitRepositoryOwner {
                    return GitRepositoryOwner(login: login ?? "", avatarURL: URL(string: avatar_url ?? ""))
                }
            }
        }
    }
    
    static func map(_ result: (data: Data, response: HTTPURLResponse)) -> Result<[GitRepositoryItem], GitRepositoryServiceError>  {
        if result.response.statusCode == 200, let apiData = decodeResponse(from: result.data) {
            return .success(apiData.items?.map({$0.repositoyItem}) ?? [])
        } else {
            return .failure(.invalidData)
        }
    }
    
    private static func decodeResponse(from data: Data) -> Root? {
        let decord = JSONDecoder()
        do {
            let response = try decord.decode(Root.self, from: data)
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
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
        let expectedResult: GitRepositoryServiceError = .internetConnectivity
        var receivedResult: GitRepositoryServiceError?

        sut.fetch(urlRequest: urlReq, completion: { result in
            switch result {
            case .failure(let err):
                receivedResult = err
            case .success:
                XCTFail("Expected Failure but fount success instead!")
            }
        })
        
        client.completesWithError(for: urlReq, error: expectedResult)
        //assert
        XCTAssert(receivedResult == expectedResult)

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
            XCTAssert(receivedResult == expectedResult)

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
        XCTAssert(receivedResult == expectedResult)
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
