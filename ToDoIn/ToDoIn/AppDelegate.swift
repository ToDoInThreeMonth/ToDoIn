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
        
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: CustomNavigationController(), title: "Главная")
        
        let accountFlowCoordinator = AccountFlowCoordinator(navigationController: CustomNavigationController(), imageName: "account", title: "Аккаунт")
        
        let groupsFlowCoordinator = GroupsFlowCoordinator(navigationController: CustomNavigationController(), imageName: "groups", title: "Комнаты")
        
        appCoordinator = AppCoordinator(tabBarController: CustomTabBarController(), childCoordinators: [accountFlowCoordinator, mainFlowCoordinator, groupsFlowCoordinator])
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }


}

