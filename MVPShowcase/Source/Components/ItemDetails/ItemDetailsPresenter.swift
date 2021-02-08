//
//  ItemDetailsPresenter.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 09.02.2021..
//

import Foundation

protocol ItemDetailsPresenterView: class {}

class ItemDetailsPresenter {

    private let itemDataModel: ItemDataModel
    
    init(with itemDataModel: ItemDataModel) {
        self.itemDataModel = itemDataModel
    }

    // MARK: - Presenter/view connection
    private weak var presenterView: ItemDetailsPresenterView?
    
    func register(_ presenterView: ItemDetailsPresenterView) {
        self.presenterView = presenterView
    }
}

// MARK: - Command interface
extension ItemDetailsPresenter {
    
    var viewTitle: String {
        return itemDataModel.name
    }
    
    var price: String {
        return String(format: "$%.2f", itemDataModel.price)
    }
    
    var description: String? {
        return itemDataModel.description
    }
    
    var location: String {
        return itemDataModel.location
    }
}
