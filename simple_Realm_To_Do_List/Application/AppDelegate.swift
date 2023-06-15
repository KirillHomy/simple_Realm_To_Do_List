//
//  AppDelegate.swift
//  simple_Realm_To_Do_List
//
//  Created by Kirill Khomicevich on 15.06.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupNavigationController()

        return true
    }


}

// MARK: - private extension
private extension AppDelegate {

    func setupNavigationController() {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}
