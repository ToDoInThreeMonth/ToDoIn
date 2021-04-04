//
//  ViewController.swift
//  ToDoIn
//
//  Created by Дарья on 24.03.2021.
//

import UIKit

class ViewController: UIViewController {
    weak var coordinator: MainChildCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        let infoVC = InfoViewController()
        present(infoVC, animated: true)
    }


}

