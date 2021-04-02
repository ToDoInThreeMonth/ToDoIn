//
//  GroupController.swift
//  ToDoIn
//
//  Created by Дарья on 02.04.2021.
//

import UIKit
import PinLayout

class GroupController: UIViewController {
    
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        label.textColor = .black
        
        view.addSubview(label)
    }
    
    override func viewDidLayoutSubviews() {
        label.pin.center()
    }

}
