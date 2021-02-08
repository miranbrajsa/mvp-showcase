//
//  BackendAPIStore+ItemListingStore.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation

extension BackendAPIStore: ItemListingStore {
    
    func fetchListing(completion: @escaping ([ItemDataModel]) -> ()) {
        guard let url = backendURL else {
            completion([])
            return
        }

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 20)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)

                completion([])
                return
            }
            guard let data = data else {
                completion([])
                return
            }
        
            do {
                let apiResult = try JSONDecoder().decode(ListingDataModel.self, from: data)
                completion(apiResult.items)
            }
            catch {
                print(error)
                completion([])
            }
       }.resume()
    }
}
