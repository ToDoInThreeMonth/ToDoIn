import UIKit

//MARK: - AccountController
protocol AccountViewPresenter {
    func showExitAlertController(completion: @escaping () -> ())
    func showErrorAlertController(with message: String)
    func toggleNotifications() -> UIImage?
    func getFriends(from text: String) -> [FriendModelProtocol]
    func getAllFriends() -> [FriendModelProtocol]
}

protocol FriendsTableViewOutput: class {
    var users: [FriendModelProtocol] { get }
    func showErrorAlertController(with message: String)
}
