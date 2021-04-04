//
//  InfoView.swift
//  ToDoIn
//
//  Created by Василий Ярынич on 04.04.2021.
//

import Foundation
import UIKit
import PinLayout

class InfoViewController: UIViewController{
    var helloLable: UILabel!
    var textView: UITextView!
    var barView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.953, green: 0.969, blue: 0.98, alpha: 1)
        
        
        helloLable = UILabel()
        helloLable.numberOfLines = 2
        helloLable.text = "Добро пожаловать в приложение \n ToDoIn!"
        helloLable.textAlignment = .center
        helloLable.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        view.addSubview(helloLable)
        
        //helloLable.translatesAutoresizingMaskIntoConstraints = false
        //helloLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        //helloLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        //helloLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        
        
        textView = UITextView()
        textView.text = "В данный момент вы находитесь на главном экране. \n \n Здесь вы можете добавлять новые задачи и секции, как группы, для задач. \n \n Чтобы создать новую секцию, достаточно нажать на Вову с полюсом сверху справа..."
        textView.textColor = UIColor.black
        textView.textAlignment = .left
        textView.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(textView)
    
        //textView.translatesAutoresizingMaskIntoConstraints = false
        //textView.topAnchor.constraint(equalTo: helloLable.bottomAnchor, constant: -50).isActive = true
        //textView.leadingAnchor.constraint(equalTo: helloLable.leadingAnchor).isActive = true
        //textView.trailingAnchor.constraint(equalTo: helloLable.trailingAnchor).isActive = true
    
        barView = UIView()
        barView.layer.cornerRadius = 3
        barView.layer.masksToBounds = true;
        view.addSubview(barView)
        
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        view.backgroundColor = UIColor(red: 0.953, green: 0.969, blue: 0.98, alpha: 1)
        
        helloLable.pin.topCenter(70).sizeToFit()
        
        textView.backgroundColor = .clear
        textView.pin.horizontally(30)
        textView.pin.below(of: helloLable, aligned: .center).marginTop(50).sizeToFit()
    
        barView.backgroundColor = .lightGray
        barView.pin.height(6)
        barView.pin.width(100)
        barView.pin.above(of: helloLable, aligned: .center).margin(30).sizeToFit()
    }
}
