import UIKit

protocol MainChildCoordinator: ChildCoordinator {
    func presentAddTaskController(with section: Int)
    func presentChangeTaskController(with task: OfflineTask, in indexPath: IndexPath, isArchive: Bool)
    func showAddSectionController()
    func showChangeSectionController(with section: Int, output: ChangeSectionAlertDelegate)
    func presentDeleteSectionController(_ number: Int)
    func presentDeleteTaskController(on viewController: UIViewController, completion: @escaping () -> ())
}

class MainFlowCoordinator: MainChildCoordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let presenter = MainPresenter(coordinator: self)
        let viewController = MainViewController(presenter: presenter)
        presenter.setRealmOutput(viewController)
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func presentAddTaskController(with section: Int) {
        guard let delegate = navigationController.viewControllers.last as? MainViewController else { return }
        let indexPath = IndexPath(row: 0, section: section)
        let controller = OfflineTaskController(indexPath: indexPath, isChanging: false)
        controller.setPresenter(presenter: OfflineTaskPresenter(taskView: controller.self), coordinator: self)
        
        controller.delegate = delegate
        navigationController.present(controller, animated: true)
    }
    
    func presentChangeTaskController(with task: OfflineTask, in indexPath: IndexPath, isArchive: Bool) {
        let controller = OfflineTaskController(task: task, indexPath: indexPath, isChanging: isArchive ? false : true, isArchive: isArchive)
        controller.setPresenter(presenter: OfflineTaskPresenter(taskView: controller.self), coordinator: self)
        navigationController.present(controller, animated: true)
    }
    
    func showAddSectionController() {
        guard let controller = navigationController.viewControllers.last as? MainViewController,
              let alertController = AlertControllerCreator.getController(title: "???????????????????? ?????????? ????????????", message: "?????????????? ????????????????", style: .alert, type: .addSection) as? AddSectionAlertController else { return }
        alertController.delegate = controller
        
        navigationController.present(alertController, animated: true)
    }
    
    func showChangeSectionController(with section: Int, output: ChangeSectionAlertDelegate) {
        guard let alertController = AlertControllerCreator.getController(title: "?????????????????? ???????????????? ????????????", message: "?????????????? ?????????? ???????????????? ???????? ?? ?????????????? \"??????????????????\"", style: .alert, type: .changeSection) as? ChangeSectionAlertController
        else { return }
        alertController.delegate = output
        alertController.section = section
        
        navigationController.present(alertController, animated: true)
    }
    
    func presentDeleteSectionController(_ number: Int) {
        guard let controller = navigationController.viewControllers.last as? MainViewController else { return }
        guard let alertController = AlertControllerCreator.getController(title: "???????????????? ?????????????", message: "???? ?????????????????????????? ???????????? ?????????????? ?????????????", style: .alert, type: .deleteSection) as? DeleteSectionAlertController else { return }
        alertController.delegate = controller
        alertController.section = number
        
        navigationController.present(alertController, animated: true)
    }
    
    func presentDeleteTaskController(on viewController: UIViewController, completion: @escaping () -> ()) {
        let alertTitle = "???????????????? ????????????"
        let alertMessage = "???? ?????????????????????????? ???????????? ?????????????? ?????????????"
        guard let alertVC = AlertControllerCreator.getController(title: alertTitle, message: alertMessage, style: .alert, type: .logOut) as? ExitAlertController else { return }
        alertVC.onButtonTapped = completion
        viewController.present(alertVC, animated: true, completion: nil)
    }
}
