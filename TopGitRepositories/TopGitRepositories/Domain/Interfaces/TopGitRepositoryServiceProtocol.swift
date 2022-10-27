//
//  TopGitRepositoryServiceProtocol.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

enum GitRepositoryServiceError: Swift.Error {
    
    case invalidData
    case clientError(error: Error)
}

extension GitRepositoryServiceError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return NSLocalizedString("Something went wrong!", comment: "")
        case .clientError(let err):
            return NSLocalizedString(err.localizedDescription, comment: "")
        }
    }
}


protocol TopGitRepositoryServiceProtocol {
    
    func fetch(urlRequest: URLRequest, completion: @escaping(Result<[GitRepositoryItem], GitRepositoryServiceError>) -> Void)
}
