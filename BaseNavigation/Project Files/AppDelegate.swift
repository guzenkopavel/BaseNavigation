//
//  AppDelegate.swift
//  BaseNavigation
//
//  Created by Pavel Guzenko on 14.12.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.keyWindow?.rootViewController = UINavigationController(rootViewController: MainScreenViewController())
        return true
    }
}

