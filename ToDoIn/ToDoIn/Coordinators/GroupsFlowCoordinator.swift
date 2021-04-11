import UIKit


class GroupsFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let groupsController = GroupsController()
        var tabBarImage: UIImage?
        tabBarImage = UIImage(named: imageName)
        
        // Пример настройки tabBar'a
        groupsController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        // Пример настройки viewController (title и barButtonItem)
        groupsController.view.backgroundColor = .white
        groupsController.title = title
        
        navigationController.pushViewController(groupsController, animated: false)
    }
    
    //  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
        func showAddSection() {}
        func showAddTask() {}
}

