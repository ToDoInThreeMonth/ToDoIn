import Foundation
import UIKit

protocol GroupsViewPresenter {
    var groupsCount: Int { get }
    
    init(groupsView: GroupsView)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func didLoadView()
    
    func getGroup(at index: Int) -> Group
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)

    func showGroupController(group: Group)
    
    func addGroupButtonTapped()
    
    func showErrorAlertController(with message: String)
}

class GroupsPresenter: GroupsViewPresenter {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsView: GroupsView?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    private let authManager: AuthManagerDescription = AuthManager.shared
    
    private var groups: [Group] = []
    
    var groupsCount: Int {
        groups.count
    }
    
    // MARK: - Init
    
    required init(groupsView: GroupsView) {
        self.groupsView = groupsView
    }
    
    // MARK: - Configures
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Handlers

    func getGroup(at index: Int) -> Group {
        return groups[index]
    }
    
    func showGroupController(group: Group) {
        coordinator?.showGroupController(group: group)
    }
    
    func addGroupButtonTapped() {
        if authManager.isSignedIn() {
            coordinator?.showAddGroup()
        }
    }
    
    func didLoadView() {
        if authManager.isSignedIn() {
            groupsManager.observeGroups { [weak self] (result) in
                switch result {
                case .success(let groups):
                    self?.groups = groups.map { $0 }
                    self?.groupsView?.reloadView()
                case .failure(let error):
                    self?.groups.removeAll()
                    self?.groupsView?.reloadView()
                    self?.showErrorAlertController(with: error.toString())
                }
            }
        } else {
            groups.removeAll()
            groupsView?.reloadView()
        }
    }
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        ImagesManager.loadPhoto(url: url) { (result) in
            switch result {
            case .success(let resImage):
                completion(resImage)
            case .failure(_):
                completion(UIImage(named: "default") ?? UIImage())
            }
        }
    }
    
    func showErrorAlertController(with message: String) {
        coordinator?.presentErrorController(with: message)
    }
}
