//
//  ItemDataModel.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import Foundation

struct ItemDataModel: Decodable {
    let uid:         String
    let name:        String
    let description: String?
    let price:       Float
    let location:    String
}
