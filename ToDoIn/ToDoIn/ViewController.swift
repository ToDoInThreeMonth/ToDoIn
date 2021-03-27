//
//  ViewController.swift
//  ToDoIn
//
//  Created by Дарья on 24.03.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Vova che za xuynya")
        
        setupNavigationBar()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func setupNavigationBar() {
     
        navigationItem.title = "ToDoIn"
        
        let backNaviBarImage = UIImage(named: "Vector")
        self.navigationController?.navigationBar.setBackgroundImage(backNaviBarImage, for: .default)
        
        let groupButtonImage = UIImage(named: "groupButton")
        let renderedGroupImage = groupButtonImage?.withRenderingMode(.alwaysOriginal)
        let groupButton = UIButton(type: .system)
        
        groupButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        groupButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        groupButton.setImage(renderedGroupImage, for: .normal)
   // groupButton.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: groupButton)
        
       
        
        let addSectionImage = UIImage(named: "addSection")
        let renderedAddSectionImage = addSectionImage?.withRenderingMode(.alwaysOriginal)
        let addSectionButton = UIButton(type: .system)
        addSectionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        addSectionButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
        addSectionButton.setImage(renderedAddSectionImage, for: .normal)
   //   addSectionButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addSectionButton)
        


    }
    
    
    
    

}

