//
//  TopGitRepositoryEndpoint.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

enum TopGitRepositoryEndpoint: Routable {
   
    case getTopGitRepos
    
    var baseURL: String {
        return "https://api.github.com"
    }
    
    var path: String {
        switch self {
        case .getTopGitRepos:
            return  "/search/repositories?q=language=+sort:stars"
        }
    }
    var params: APIParams? {
        switch self {
        case .getTopGitRepos:
            return nil
        }
    }
    
    var method: APIMehtod {
        switch self {
        case .getTopGitRepos:
            return .get
        }
    }
    
    var headers: APIHeaders? {
       return ["Content-Type": "application/json"]
    }
    
    var parameterEncoding: EncodingType {
        switch self {
        case .getTopGitRepos:
            return .urlEncoding
        }
    }
    
}
