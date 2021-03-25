import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showAddTask()
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = ViewController()
        controller.coordinator = self
//        Пример настройки tabBar'a
//        controller.tabBarItem = TabBarModel.items[.profile]
        
        navigationController.pushViewController(controller, animated: false)
    }
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
}
