//
//  LocalizeStrings.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import Foundation

enum LocalizedStrings: String, Localizable {
    case listTitle = "list_title"
    case retryTitle = "retry_title"
    case noInternetTitle = "no_internet_title"
    case noInternetDescription = "no_internet_description"
    
    var tableName: String {
        return "Localized"
    }
}
