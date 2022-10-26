//
//  URLSessionClientTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import XCTest
@testable import TopGitRepositories

class URLSessionClient: HTTPClient {
    
    let session: URLSession
    
    init(_ _session: URLSession = URLSession.shared) {
        session = _session
    }
    
    
    func perform(urlRequest: URLRequest, completion: @escaping (HttpClientResult) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

}

class URLSessionClientTest: XCTestCase {

    func test_perform_deliversFailureOnRequestError() throws {
        
        URLProtocol.registerClass(URLProtocolStub.self)
        
        let urlRequest = URLRequest(url: URL(string: "https://sadapay.com")!)
        let sut = URLSessionClient()
        
        let expectedError = NSError(domain: "some-domain", code: 400)
        var receivedError: NSError?
        
        URLProtocolStub.stub(error: expectedError, data: nil, response: nil, for: urlRequest.url!)
        
        let expectation = expectation(description: "Fails with error")
        sut.perform(urlRequest: urlRequest) { result in
            switch result {
            case .success:
                XCTFail("Expected to have an error but found success instead!")
            case .failure(let error as NSError):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        URLProtocol.unregisterClass(URLProtocolStub.self)
        XCTAssertEqual(receivedError?.code, expectedError.code)
    }
    
    func test_perform_deliversFailureOnInvalidStates() throws {
        
        URLProtocol.registerClass(URLProtocolStub.self)
        
        let urlRequest = URLRequest(url: URL(string: "https://sadapay.com")!)
        let sut = URLSessionClient()
        
        
        let expectedError = NSError(domain: "some-domain", code: 400)
        var receivedError: NSError?
        
        URLProtocolStub.stub(error: expectedError, data: nil, response: nil, for: urlRequest.url!)
        
        let expectation = expectation(description: "Fails with error")
        sut.perform(urlRequest: urlRequest) { result in
            switch result {
            case .success:
                XCTFail("Expected to have an error but found success instead!")
            case .failure(let error as NSError):
                receivedError = error
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        URLProtocol.unregisterClass(URLProtocolStub.self)
        XCTAssertEqual(receivedError?.code, expectedError.code)
    }

    
    //MARK: - Helpers
    
    class URLProtocolStub: URLProtocol {
        
        static private  var stubsForURLs: [URL: Stub] = [:]
        
        private struct Stub {
            let error: Error?
            let data: Data?
            let response: URLResponse?
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true // we intercept the request and handle it
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            guard let url = request.url, let stub = URLProtocolStub.stubsForURLs[url]  else { fatalError() }
            
            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let err = stub.error {
                client?.urlProtocol(self, didFailWithError: err)
            }
            
            client?.urlProtocolDidFinishLoading(self)
            
            
        }
        
        override func stopLoading() {
            
        }
        
        static func stub(error: Error?, data: Data?, response: URLResponse?, for URL: URL) {
            URLProtocolStub.stubsForURLs[URL] = Stub(error: error, data: data, response: response)
        }
    }

}
