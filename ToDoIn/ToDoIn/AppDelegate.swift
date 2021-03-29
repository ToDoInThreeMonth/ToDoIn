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
        
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: UINavigationController(), imageName: "", title: "Главная")
        
        let acountFlowCoordinator = MainFlowCoordinator(navigationController: UINavigationController(), imageName: "account", title: "Аккаунт")
        
        let settingsFlowCoordinator = MainFlowCoordinator(navigationController: UINavigationController(), imageName: "settings", title: "Настройки")
        
        appCoordinator = AppCoordinator(tabBarController: CustomTabBarController(), childCoordinators: [acountFlowCoordinator, mainFlowCoordinator, settingsFlowCoordinator])
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }


}

