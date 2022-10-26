//
//  TopGitRepositoryService.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

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
