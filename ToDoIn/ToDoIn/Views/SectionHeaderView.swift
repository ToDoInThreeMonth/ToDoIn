//
//  SectionHeaderView.swift
//  ToDoIn
//
//  Created by Дарья on 03.04.2021.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SectionHeaderView"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        configureLabel()
    }
    
    func setupLayouts() {
        label.pin.left(50)
            .bottom(5)
            .sizeToFit()
    }
    
    
    func configureLabel() {
        label.font = UIFont(name: "Inter-Regular", size: 12)
        label.textColor = .darkTextColor
    }
    
    
    func setUp(owner: String) {
        label.text = owner
    }
        
}
