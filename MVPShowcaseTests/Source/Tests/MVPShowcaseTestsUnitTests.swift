//
//  MVPShowcaseTestsUnitTests.swift
//  MVPShowcaseTests
//
//  Created by Miran Brajsa on 09.02.2021..
//

import XCTest
@testable import MVPShowcase

class MVPShowcaseUnitTests: MVPShowcaseTestsBase {

    private var store: TestMockupStore!
    private var presenter: ItemListingPresenter!
    
    override func setUpWithError() throws {
        guard let jsonData = loadJSONData(from: "dummyData") else { return }
        
        store = TestMockupStore()
        store.prepare(with: jsonData)
        
        presenter = ItemListingPresenter(with: store)
        presenter.requestListingData()
    }

    func testThat_ItemListingPresenter_CorrectlyReturns_Nil_IfRequestingAModelOutsideOfScope() throws {
        XCTAssertNil(presenter.dataModel(for: IndexPath(row: 20, section: 1)))
    }

    func testThat_ItemListingPresenter_CorrectlyReturns_AllStoreModels_WhenUnfiltered() throws {
        let expectation = self.expectation(description: "ItemListingPresenterExpectation")
        
        // We're dispatching here due to async nature of presenter's data processing.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            defer { expectation.fulfill() }
            guard let self = self else {
                XCTFail()
                return
            }
            let allModels = self.presenterModels(of: self.presenter)
            XCTAssertEqual(allModels.count, 5)
        }
        waitForExpectations(timeout: testsTimeout)
    }

    func testThat_ItemListingPresenter_CorrectlyReturns_LosAngelesBasedModels_WhenFilteredByLocation() throws {
        let expectation = self.expectation(description: "ItemListingPresenterExpectation")
        
        filteringTestWorker(expectation) { [weak self] in
            self?.presenter.filterData(byLocationSearchString: "Los Ange")
            XCTAssertEqual(self?.presenter.modelCount(), 3)
        }
    }

    func testThat_ItemListingPresenter_CorrectlyReturns_TwoLosAngelesBasedModels_FilteredByAWordNice() throws {
        let expectation = self.expectation(description: "ItemListingPresenterExpectation")
        
        filteringTestWorker(expectation) { [weak self] in
            self?.presenter.filterData(byLocationSearchString: "Los")
            self?.presenter.filterData(byGenericSearchString: "nice")
            XCTAssertEqual(self?.presenter.modelCount(), 2)

            let itemUids = [
                self?.presenter.dataModel(for: IndexPath(row: 0, section: 0)),
                self?.presenter.dataModel(for: IndexPath(row: 1, section: 0))
            ].compactMap { $0?.uid }
            XCTAssertEqual(itemUids.sorted(), ["4", "5"].sorted())
        }
    }
    
    private func filteringTestWorker(_ expectation: XCTestExpectation, filteringClosure: @escaping () -> ()) {
        // We're dispatching here due to async nature of presenter's data processing.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            filteringClosure()
            expectation.fulfill()
        }
        waitForExpectations(timeout: testsTimeout)
    }
}

extension MVPShowcaseUnitTests {

    private func presenterModels(of presenter: ItemListingPresenter) -> [ItemDataModel] {
        let models: [ItemDataModel] = privateMember(of: presenter, named: "models")!
        return models
    }

    private func privateMember<T>(of presenter: ItemListingPresenter, named memberName: String) -> T? {
        let presenterMirror = Mirror(reflecting: presenter)
        var privateMember: T?
        for (name, value) in presenterMirror.children {
            guard name == memberName,
                let member = value as? T
                else { continue }
            
            privateMember = member
        }
        return privateMember
    }
}
