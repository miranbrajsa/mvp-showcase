//
//  MVPShowcaseTests.swift
//  MVPShowcaseTests
//
//  Created by Miran Brajsa on 08.02.2021..
//

import XCTest

class MVPShowcaseTestsBase: XCTestCase {
    
    let testsTimeout: TimeInterval = 20
    
    lazy var testBundle: Bundle = {
        return Bundle(for: MVPShowcaseTestsBase.self)
    }()
    
    private func bundleURL(for filename: String, fileExtension: String) -> URL? {
        return testBundle.url(forResource: filename, withExtension: fileExtension)
    }
    
    func loadJSONData(from filename: String) -> Data? {
        guard let url = bundleURL(for: filename, fileExtension: "json"),
              let jsonData = try? Data(contentsOf: url)
            else { return nil }

        return jsonData
    }
}
