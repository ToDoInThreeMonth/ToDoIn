import Foundation
import UIKit

protocol GroupsPresenterProtocol {
    var groupsCount: Int { get }
    
    init(groupsView: GroupsViewProtocol)
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func loadData()

    func getGroup(at index: Int) -> Group
    func loadImage(url: String, completion: @escaping (UIImage) -> Void)

    func showGroupController(group: Group)
    func showErrorAlertController(with message: String)
    
    func addGroupButtonTapped()
    func deleteTapped(for group: Group, at index: Int)
    
    func isSignedIn() -> Bool
}

final class GroupsPresenter: GroupsPresenterProtocol {
    
    // MARK: - Properties
    
    weak var coordinator: GroupsChildCoordinator?
    
    private let groupsView: GroupsViewProtocol?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    private let authManager: AuthManagerDescription = AuthManager.shared
    
    private var groups: [Group] = []
    
    var groupsCount: Int {
        groups.count
    }
    
    // MARK: - Init
    
    required init(groupsView: GroupsViewProtocol) {
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
    
    func deleteTapped(for group: Group, at index: Int) {
        groupsManager.deleteGroup(group) { [weak self] (err) in
            guard let self = self else { return }
            guard let err = err else {
                self.loadData()
                return
            }
            self.showErrorAlertController(with: err.toString())
        }
    }
    
    func loadData() {
        if authManager.isSignedIn() {
            groupsManager.getGroups { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let groups):
                    self.groups = groups.map { $0 }
                    self.groupsView?.reloadView()
                case .failure(let error):
                    self.groups.removeAll()
                    self.groupsView?.reloadView()
                    self.showErrorAlertController(with: error.toString())
                }
            }
        } else {
            groups.removeAll()
            groupsView?.reloadView()
        }
    }
    
    func loadImage(url: String, completion: @escaping (UIImage) -> Void) {
        ImagesManager.loadPhotoFromStorage(url: url) { (result) in
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
    
    func isSignedIn() -> Bool {
        authManager.isSignedIn()
    }
}
