//
//  URLSessionClient.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

class URLSessionClient: HTTPClient {
    
    let session: URLSession
    
    init(_ _session: URLSession = URLSession.shared) {
        session = _session
    }
    
    struct UnExpectedError: Error {}
    
    func perform(urlRequest: URLRequest, completion: @escaping (HttpClientResult) -> Void) {
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success((data: data, response: response)))
            }else {
                completion(.failure(UnExpectedError()))
            }
        }
        
        task.resume()
    }

}
