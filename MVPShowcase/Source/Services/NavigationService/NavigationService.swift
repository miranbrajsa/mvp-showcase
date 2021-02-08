//
//  NavigationService.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

class NavigationService {

    private let application: UIApplication
    private let window: UIWindow

    private let itemListingNavigationController = UINavigationController()
    
    private let backendAPIStore: DataStore
    
    init(with application: UIApplication, window: UIWindow) {
        self.application = application
        self.window = window

        backendAPIStore = BackendAPIStore()
    }
    
    func presentInitialViewController() {
        let itemListingPresenter = ItemListingPresenter(with: backendAPIStore) { [weak self] itemDataModel in
            guard let self = self else { return }
            
            let itemDetailsVC = self.createItemDetailsViewController(for: itemDataModel)
            self.itemListingNavigationController.pushViewController(itemDetailsVC, animated: true)
        }
        let itemListingVC = ItemListingViewController(with: itemListingPresenter)
        
        itemListingNavigationController.viewControllers = [itemListingVC]
        window.rootViewController = itemListingNavigationController
        window.makeKeyAndVisible()
    }
}
