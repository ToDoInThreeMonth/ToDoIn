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
        
        let mainFlowCoordinator = MainFlowCoordinator(navigationController: UINavigationController(), title: "Главная")
        
        let acountFlowCoordinator = AccountFlowCoordinator(navigationController: UINavigationController(), imageName: "account", title: "Аккаунт")
        
        let groupsFlowCoordinator = GroupsFlowCoordinator(navigationController: UINavigationController(), imageName: "groups", title: "Комнаты")
        
        appCoordinator = AppCoordinator(tabBarController: CustomTabBarController(), childCoordinators: [acountFlowCoordinator, mainFlowCoordinator, groupsFlowCoordinator])
        appCoordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator?.tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }


}

