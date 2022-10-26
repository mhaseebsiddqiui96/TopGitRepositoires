//
//  GitRepositoryItemMapper.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/27/22.
//

import Foundation

struct GitRepositoryItemMapper {
    
    struct Root: Decodable {
        let items: [GitRepositoryDataModel]?
        
        struct GitRepositoryDataModel: Decodable {
            let id: Int
            let name: String?
            let full_name: String?
            let owner: OwnerDataModel?
            let description: String?
            let language: String?
            let stargazers_count: Int?
            
            var repositoyItem: GitRepositoryItem {
                return GitRepositoryItem(id: id, language: language ?? "", name: full_name ?? "", starsCount: stargazers_count ?? 0, description: description ?? "", owner: owner?.ownerItem)
            }

            struct OwnerDataModel : Codable {
                let login : String?
                let avatar_url : String?
                
                var ownerItem: GitRepositoryOwner {
                    return GitRepositoryOwner(login: login ?? "", avatarURL: URL(string: avatar_url ?? ""))
                }
            }
        }
    }
    
    static func map(_ result: (data: Data, response: HTTPURLResponse)) -> Result<[GitRepositoryItem], GitRepositoryServiceError>  {
        if result.response.statusCode == 200, let apiData = decodeResponse(from: result.data) {
            return .success(apiData.items?.map({$0.repositoyItem}) ?? [])
        } else {
            return .failure(.invalidData)
        }
    }
    
    private static func decodeResponse(from data: Data) -> Root? {
        let decord = JSONDecoder()
        do {
            let response = try decord.decode(Root.self, from: data)
            return response
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
