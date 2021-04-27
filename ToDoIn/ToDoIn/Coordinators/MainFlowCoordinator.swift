import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func showPostInfo(post: Post, in section: Section, isChanging: Bool)
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    private let title: String
    
    init(navigationController: UINavigationController, title: String) {
        self.navigationController = navigationController
        self.title = title
    }
    
    func start() {
        let viewController = MainController()
        viewController.setPresenter(presenter: MainPresenter(mainView: viewController.self), coordinator: self)

        // Пример настройки tabBar'a
        viewController.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
        
        // Пример настройки viewController
        viewController.view.backgroundColor = .white
        viewController.title = title
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showPostInfo(post: Post, in section: Section, isChanging: Bool) {
        navigationController.viewControllers.last?.present(TaskSectionController(section: section, post: post, isChanging: isChanging), animated: true, completion: nil)
    }
}
