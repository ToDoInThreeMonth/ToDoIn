import UIKit

class AccountPresenter: AccountViewPresenter {
    
    // Stored properties
    private weak var coordinator: AccountChildCoordinator?
    private var isNotificationTurnedOn = false
    
    init(coordinator: AccountChildCoordinator) {
        self.coordinator = coordinator
    }
    
    func showExitAlertController(completion: @escaping () -> ()) {
        coordinator?.presentExitController(completion: completion)
    }
    
    func toggleNotifications() -> UIImage? {
        // Включение/Выключение уведомлений
        isNotificationTurnedOn.toggle()
        if isNotificationTurnedOn {
            return UIImage(named: "turnedNotification")?.withRenderingMode(.alwaysOriginal)
        } else {
            return UIImage(named: "offNotification")?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    func getFriends(from text: String) -> [FriendModelProtocol] {
        // Реализация поиска
        return []
    }
    
    func showErrorAlertController(with message: String) {
        coordinator?.presentErrorController(with: message)
    }
    
    func getAllFriends() -> [FriendModelProtocol] {
        return FriendBase.friends
    }
    
    func addNewFriend(_ mail: String) {
        FriendBase.addNewFriend(mail)
    }
}
