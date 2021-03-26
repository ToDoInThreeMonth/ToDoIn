//
//  AppDelegate.swift
//  ToDoIn
//
//  Created by Дарья on 24.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: UINavigationController())
        
        let acountFlowCoordinator = AccountFlowCoordinator(navigationController: UINavigationController())
        
        let settingsFlowCoordinator = SettingsFlowCoordinator(navigationController: UINavigationController())
        
        appCoordinator = AppCoordinator(tabBarController: CustomTabBarController(), childCoordinators: [mainFlowCoordinator, acountFlowCoordinator, settingsFlowCoordinator])
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }


}

