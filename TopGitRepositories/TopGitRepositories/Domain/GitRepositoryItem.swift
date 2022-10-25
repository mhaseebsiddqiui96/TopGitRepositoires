//
//  GitRepositoryItem.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/25/22.
//

import Foundation

struct GitRepositoryItem: Identifiable {
    
    typealias Identifier = String
    
    let id: Identifier
    let language: String
    let name: String
    let starsCount: Int
    let description: String
    let owner: GitRepositoryOwner
    
}

struct GitRepositoryOwner {
    let login: String
    let avatarURL: URL?
}
