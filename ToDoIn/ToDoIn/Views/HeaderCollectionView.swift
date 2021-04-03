//
//  HeaderCollectionView.swift
//  ToDoIn
//
//  Created by Дарья on 03.04.2021.
//

import UIKit

class HeaderCollectionView: UICollectionReusableView {
    static let identifier = "HeaderCollectionView"
    
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
        label.pin.center().sizeToFit()
    }
    
    func configureLabel() {
        label.font = UIFont(name: "Inter-Normal", size: 20)
        label.textColor = .darkTextColor
    }
    
    func setUp(label: String) {
        self.label.text = label
    }
}
