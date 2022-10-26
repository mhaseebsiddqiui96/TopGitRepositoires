//
//  HttpClient.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

protocol HTTPClient {
    
    typealias HttpClientResult = Result<(data: Data, response: HTTPURLResponse), Error>
    
    func perform(urlRequest: URLRequest, completion: @escaping(HttpClientResult) -> Void)
}

