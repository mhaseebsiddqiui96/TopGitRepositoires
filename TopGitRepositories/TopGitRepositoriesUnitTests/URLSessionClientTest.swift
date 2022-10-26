//
//  URLSessionClientTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import XCTest
@testable import TopGitRepositories

class URLSessionClientTest: XCTestCase {
    
    override func setUpWithError() throws {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    func test_perform_deliversFailureOnRequestError() throws {
        
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
        
        
        let urlRequest = URLRequest(url: URL(string: "https://sadapay.com")!)
        let sut = URLSessionClient()
        
        [
            URLProtocolStub.StubModel(error: nil, data: nil, response: nil),
            URLProtocolStub.StubModel(error: nil, data: Data(), response: nil),
            URLProtocolStub.StubModel(error: nil, data: nil, response: URLResponse())
            
        ].forEach { model in
            
            let expectedError = URLSessionClient.UnExpectedError()
            var receivedError: NSError?
            
            URLProtocolStub.stub(error: model.error, data: model.data, response: model.response, for: urlRequest.url!)
            
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
            XCTAssertEqual(receivedError, expectedError as NSError)
        }
        
    }
    
    func test_perform_deliversSuccessOnValidState() throws {
        
        let urlRequest = URLRequest(url: URL(string: "https://sadapay.com")!)
        
        let sut = URLSessionClient()
        
        var receivedResult: (data: Data, response: HTTPURLResponse)?
        
        let expectation = expectation(description: "Fails with error")
        
        URLProtocolStub.stub(error: nil, data: Data(), response: HTTPURLResponse(), for: urlRequest.url!)
        sut.perform(urlRequest: urlRequest) { result in
            switch result {
            case .success(let result):
                receivedResult = result
            case .failure:
                XCTFail("Expected to have an error but found success instead!")
                
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        
        URLProtocol.unregisterClass(URLProtocolStub.self)
        XCTAssertNotNil(receivedResult)
    }
    
    override func tearDown() {
        super.tearDown()
        
        URLProtocol.unregisterClass(URLProtocolStub.self)
    }

    
    //MARK: - Helpers
    
    class URLProtocolStub: URLProtocol {
        
        struct StubModel {
            let error: Error?
            let data: Data?
            let response: URLResponse?
        }

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
