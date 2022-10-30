//
//  GitRepositoryViewModel.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import Foundation

struct GitRepositoryViewModel: Equatable {
    let id: Int
    let userName: String
    let avtarURL: URL?
    let repoName: String
    let repoDescription: String
    let starsCount: Int
    let language: String

}

extension GitRepositoryViewModel {
    init(model: GitRepositoryItem) {
        self.init(id: model.id,
                  userName: model.owner?.login ?? "--",
                  avtarURL: model.owner?.avatarURL,
                  repoName: model.name,
                  repoDescription: model.description,
                  starsCount: model.starsCount,
                  language: model.language)
    }
}
