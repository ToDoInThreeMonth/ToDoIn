//
//  Protocols.swift
//  ToDoIn
//
//  Created by Philip on 03.05.2021.
//

import Foundation

protocol GroupViewPresenter {
    func setCoordinator()
    func getTasks()
    func showSettingsGroupController()
    func showTaskCotroller()
}
