//
//  Reactive.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/28/22.
//

import Foundation
import UIKit

class Reactive<T> {
    typealias Listner = (T?) -> Void
    var listner: [Listner?] = [Listner?]()
    
    var value: T? {
        didSet {
            for l in listner {
                l?(value)
            }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(listner: Listner?) {
        self.listner.append(listner)
        listner?(value)
    }
}

