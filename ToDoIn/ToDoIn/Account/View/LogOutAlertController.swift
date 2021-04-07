//
//  LogOutAlertController.swift
//  ToDoIn
//
//  Created by Tsar on 07.04.2021.
//

import UIKit

class LogOutAlertController: UIAlertController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    private func setupButton() {
        let agreeButton = UIAlertAction(title: "Нет", style: .default, handler: nil)
        let disagreeButton = UIAlertAction(title: "Да", style: .destructive) {[unowned self] _ in
            //  заглушка
        }
        addAction(disagreeButton)
        addAction(agreeButton)
    }

}
