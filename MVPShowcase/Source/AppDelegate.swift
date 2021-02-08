//
//  AppDelegate.swift
//  MVPShowcase
//
//  Created by Miran Brajsa on 08.02.2021..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var navigationService: NavigationService!

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else {
            fatalError("Window could not be initialized.")
        }

        navigationService = NavigationService(with: application, window: window)
        navigationService.presentInitialViewController()
        
        return true
    }
}
