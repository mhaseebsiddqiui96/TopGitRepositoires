//
//  Error+Ext.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import Foundation

extension Error {
    var isNoInternetError: Bool {
        let code = URLError.Code(rawValue: (self as NSError).code)
        switch code {
        case .notConnectedToInternet, .timedOut: return true
        default: return false
        }
    }
}
