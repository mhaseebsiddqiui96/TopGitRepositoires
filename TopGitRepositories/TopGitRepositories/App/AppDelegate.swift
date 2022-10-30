//
//  AppDelegate.swift
//  TopGitRepositories
//
//  Created by Muhammad Haseeb Siddiqui on 10/22/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController:  TopGitRepositoriesListViewController(viewModel: TopGitRepositoriesListViewModel(service: TopGitRepositoriesService(client: URLSessionClient()))))
        window?.makeKeyAndVisible()
        return true
    }

}

