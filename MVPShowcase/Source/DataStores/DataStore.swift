//
//  DataStore.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation

protocol DataStore {}

protocol ItemListingStore: DataStore {
    func fetchListing(completion: @escaping ([ItemDataModel]) -> ())
}
