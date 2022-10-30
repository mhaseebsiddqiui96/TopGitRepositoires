//
//  Localizable.swift
//  TopStories
//
//  Created by Muhammad Haseeb Siddiqui on 9/9/22.
//

import Foundation

protocol Localizable {
    var tableName: String { get }
    var localized: String { get }
}

// 1
extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(tableName: tableName)
    }
}

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
