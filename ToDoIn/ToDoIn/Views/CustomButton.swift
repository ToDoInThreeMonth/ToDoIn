//
//  CustomButton.swift
//  ToDoIn
//
//  Created by Дарья on 09.04.2021.
//

import UIKit

class CustomButton: UIButton {

    // MARK: - Properties
    
    private let label = UILabel()
    

    // MARK: - Init
    
    init(title: String) {
        label.text = title
        label.textColor = .darkTextColor
        super.init(frame: .zero)
        backgroundColor = .white
        addMyShadow(color: .black, offset: CGSize(width: 0, height: -1), radius: 2, opacity: 0.10)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Handlers
    
    override func layoutSubviews() {
        label.pin.center().sizeToFit()
    }
    
}
