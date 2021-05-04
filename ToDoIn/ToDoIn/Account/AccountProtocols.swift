import UIKit

//MARK: - AccountController
protocol AccountViewPresenter {
    func showExitAlertController()
    func showErrorAlertController(with message: String)
    func toggleNotifications() -> UIImage?
    func getFriends(from text: String) -> [FriendModelProtocol]
    func getAllFriends() -> [FriendModelProtocol]
}
