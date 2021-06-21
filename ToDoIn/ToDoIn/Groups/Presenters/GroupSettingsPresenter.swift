import Foundation
import UIKit

protocol GroupSettingsPresenterProtocol {
    func didLoadView()
    func setCoordinator(with coordinator: GroupsChildCoordinator)
    func setDelegate(_ delegate: GroupsViewProtocol?)
    
    var usersCount: Int { get }
    
    func groupTitleDidChange(with title: String)
    func addUserButtonTapped()
    func deleteTapped(for user: User, in group: Group)
    func imageIsChanged(with image: UIImage?)
    
    func getUser(by section: Int) -> User
    func getAllUsers() -> [User]
    
    func loadImage(id: String, completion: @escaping (UIImage) -> Void)
}

final class GroupSettingsPresenter: GroupSettingsPresenterProtocol {
    
    // MARK: - Properties
    
    private weak var coordinator: GroupsChildCoordinator?
    
    private weak var delegate: GroupsViewProtocol?
    
    private let groupsManager: GroupsManagerDescription = GroupsManager.shared
    
    private let groupSettingsView: GroupSettingsViewProtocol?

    private var group: Group
    private var users: [User] = []
    
    var usersCount: Int {
        users.count
    }
    
    // MARK: - Init
    
    required init(groupSettingsView: GroupSettingsViewProtocol, group: Group) {
        self.groupSettingsView = groupSettingsView
        self.group = group
    }
    
    func setCoordinator(with coordinator: GroupsChildCoordinator) {
        self.coordinator = coordinator
    }
    
    func setDelegate(_ delegate: GroupsViewProtocol?) {
        self.delegate = delegate
    }

    // MARK: - Handlers
    
    func didLoadView() {
        groupsManager.observeGroup(by: group.id) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let group):
                self.group = group
                self.getUsers(from: group.users)
            case .failure(let error):
                self.showErrorAlertController(with: error.toString())
            }
        }
    }
    
    func getUsers(from userIdArray: [String]) {
        users.removeAll()
        for userId in userIdArray {
            groupsManager.getUser(userId: userId) { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.users.append(user)
                    self.groupSettingsView?.reloadView()
                case .failure(let error):
                    self.showErrorAlertController(with: error.toString())
                }
            }
        }
    }
    
    func getUser(by section: Int) -> User {
        return section < users.count ? users[section] : User()
    }
    
    func getAllUsers() -> [User] {
        users
    }

    func groupTitleDidChange(with title: String) {
        // изменение названия комнаты
        if group.title != title {
            groupsManager.changeTitle(in: group, with: title) { [weak self] (err) in
                guard let err = err else {
                    self?.delegate?.loadData()
                    return
                }
                self?.showErrorAlertController(with: err.toString())
            }
        }
    }
    
    func addUserButtonTapped() {
        // добавление нового участника в комнату
        coordinator?.showAddUser(to: group, with: users)
    }
    
    func deleteTapped(for user: User, in group: Group) {
        groupsManager.deleteUser(user, from: group)
    }
    
    func imageIsChanged(with image: UIImage?) {
        groupsManager.changeGroupAvatar(with: image, in: group.id) { [weak self] (err) in
            guard let self = self else { return }
            if let error = err {
                self.showErrorAlertController(with: error.toString())
            } else {
                self.delegate?.loadData()
            }
        }
    }
    
    func loadImage(id: String, completion: @escaping (UIImage) -> Void) {
        ImagesManager.loadPhotoFromStorage(id: id) { (result) in
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
