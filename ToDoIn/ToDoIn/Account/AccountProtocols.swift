//
//  AccountProtocols.swift
//  ToDoIn
//
//  Created by Philip on 04.05.2021.
//

import UIKit

//MARK: - AccountController
protocol AccountViewPresenter {
    func showExitAlertController()
    func showErrorAlertController(with message: String)
    func toggleNotifications() -> UIImage?
    func getFriends(from text: String) -> [FriendModelProtocol]
    func getAllFriends() -> [FriendModelProtocol]
}
