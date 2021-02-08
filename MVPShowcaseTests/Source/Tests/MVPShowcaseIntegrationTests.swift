//
//  MVPShowcaseIntegrationTests.swift
//  MVPShowcaseTests
//
//  Created by Miran Brajsa on 09.02.2021..
//

import XCTest
@testable import MVPShowcase

class MVPShowcaseIntegrationTests: MVPShowcaseTestsBase {

    private var store: TestMockupStore!
    private var presenter: ItemListingPresenter!
    
    override func setUpWithError() throws {
        guard let jsonData = loadJSONData(from: "dummyData") else { return }
        
        store = TestMockupStore()
        store.prepare(with: jsonData)
        
        presenter = ItemListingPresenter(with: store)
    }

    func testThat_ItemListingPresenterView_CorrectlyGetsNotified_OnMainThread_AfterAListingRequestIsSent() {
        let expectation = self.expectation(description: "ItemListingPresenterExpectation")

        let mockupPresenterView = MockListingPresenterView {
            XCTAssertTrue(Thread.isMainThread)
            expectation.fulfill()
        }
        presenter.register(mockupPresenterView)
        presenter.requestListingData()

        waitForExpectations(timeout: testsTimeout)
    }
}

