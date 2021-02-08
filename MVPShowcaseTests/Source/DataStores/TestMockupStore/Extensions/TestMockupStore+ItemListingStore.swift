//
//  TestMockupStore+ItemListingStore.swift
//  MVPShowcaseTests
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation
@testable import MVPShowcase

extension TestMockupStore: ItemListingStore {
    
    func fetchListing(completion: @escaping ([ItemDataModel]) -> ()) {
        guard let data = jsonData else {
            completion([])
            return
        }
        do {
            let apiResult = try JSONDecoder().decode(ListingDataModel.self, from: data)
            completion(apiResult.items)
        }
        catch {
            completion([])
        }
    }
}
