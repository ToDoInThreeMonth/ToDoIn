import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showAddSection()
    func showAddTask()
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let imageName: String
    private let title: String
    
    init(navigationController: UINavigationController, imageName: String, title: String) {
        self.navigationController = navigationController
        self.imageName = imageName
        self.title = title
    }
    
    func start() {
        let viewController = ViewController()
        viewController.coordinator = self
        var tabBarImage: UIImage?
        tabBarImage = (imageName == "") ? nil : UIImage(named: imageName)
        
        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: tabBarImage?.withRenderingMode(.alwaysOriginal), selectedImage: tabBarImage?.withRenderingMode(.alwaysOriginal))
        
        // Пример настройки viewController (title и barButtonItem)
        viewController.view.backgroundColor = .white
        viewController.title = title
        if imageName == "" {
            let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(showGroups))
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        }
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    
//  Пока заглушки. Эти методы для вызова экранов добавления секции и задачи
    func showAddSection() {}
    func showAddTask() {}
    
    
// Селектор для View с комнатами
    @objc func showGroups() {
        print(#function)
    }
}
