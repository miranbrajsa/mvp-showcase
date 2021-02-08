//
//  TestMockupStore.swift
//  MVPShowcaseTests
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation
@testable import MVPShowcase

class TestMockupStore: DataStore {

    var jsonData: Data?

    func prepare(with jsonData: Data) {
        self.jsonData = jsonData
    }
}
