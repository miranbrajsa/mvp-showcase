//
//  BackendAPIStore.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation

class BackendAPIStore: DataStore {

    private let backendURLPath = "https://miran-various.s3-us-west-2.amazonaws.com/dummyData.json"
    
    var backendURL: URL? {
        return URL(string: backendURLPath)
    }
}
