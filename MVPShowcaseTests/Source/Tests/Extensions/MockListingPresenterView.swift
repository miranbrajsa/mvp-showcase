//
//  MockListingPresenterView.swift
//  MVPShowcaseTests
//
//  Created by Miran Brajsa on 09.02.2021..
//

import Foundation
@testable import MVPShowcase

class MockListingPresenterView: ItemListingPresenterView {
    
    private let callbackClosure: () -> ()
    
    init(with callbackClosure: @escaping () -> ()) {
        self.callbackClosure = callbackClosure
    }
    
    func updateListingTableView() {
        callbackClosure()
    }
}
