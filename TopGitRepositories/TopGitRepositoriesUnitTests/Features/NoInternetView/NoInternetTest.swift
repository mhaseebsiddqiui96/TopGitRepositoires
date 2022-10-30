//
//  NoInternetTest.swift
//  TopGitRepositoriesUnitTests
//
//  Created by Muhammad Haseeb Siddiqui on 10/31/22.
//

import XCTest
@testable import TopGitRepositories

class NoInternetTest: XCTestCase {

  
    func test_noInternetView_LabelValues() throws {
        let sut = NoInternetView(frame: UIScreen.main.bounds)
        XCTAssertEqual(sut.labelTitle.text, LocalizedStrings.noInternetTitle.localized)
        XCTAssertEqual(sut.labelDescription.text, LocalizedStrings.noInternetDescription.localized)
        XCTAssertEqual(sut.retryButton.titleLabel?.text, LocalizedStrings.retryTitle.localized)
    }
    
    func test_retryButtonTap_callsClosure() throws {
        let sut = NoInternetView(frame: UIScreen.main.bounds)
        
        var isButtonTapped = false
        sut.retryTapped = {
            isButtonTapped = true
        }
        sut.retryButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(isButtonTapped)
    }
    
}
