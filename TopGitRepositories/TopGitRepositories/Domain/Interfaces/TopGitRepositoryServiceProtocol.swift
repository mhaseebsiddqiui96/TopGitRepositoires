//
//  TopGitRepositoryServiceProtocol.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

enum GitRepositoryServiceError: Swift.Error {
    case invalidData
    case internetConnectivity
}

protocol TopGitRepositoryServiceProtocol {
    
    func fetch(urlRequest: URLRequest, completion: @escaping(Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void)
}
