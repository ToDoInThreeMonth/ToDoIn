//
//  GroupController.swift
//  ToDoIn
//
//  Created by Дарья on 02.04.2021.
//

import UIKit
import PinLayout

class GroupController: UIViewController {
    
    private let label = UILabel()
    
    init(group: Group) {
        label.text = group.name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        label.textColor = .black
        
        view.addSubview(label)
    }
    
    override func viewDidLayoutSubviews() {
        label.pin.center().sizeToFit()
    }

}
