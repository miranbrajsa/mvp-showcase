//
//  NavigationService+ItemDetails.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 09.02.2021..
//

import UIKit

extension NavigationService {

    func createItemDetailsViewController(for itemModel: ItemDataModel) -> UIViewController {
        let itemDetailsPresenter = ItemDetailsPresenter(with: itemModel)
        let itemDetailsVC = ItemDetailsViewController(with: itemDetailsPresenter)
        
        return itemDetailsVC
    }
}
