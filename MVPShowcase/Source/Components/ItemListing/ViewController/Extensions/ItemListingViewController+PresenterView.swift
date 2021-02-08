//
//  ItemListingViewController+PresenterView.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

extension ItemListingViewController: ItemListingPresenterView {
    
    func updateListingTableView() {
        tableView.reloadData()
    }
}
