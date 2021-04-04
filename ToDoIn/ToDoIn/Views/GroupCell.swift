//
//  GroupCell.swift
//  ToDoIn
//
//  Created by Дарья on 02.04.2021.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "GroupCell"
    
    var groupView = UIView()
    var groupLabel = UILabel()
    var groupImageView = UIImageView()
    
    private let imagePadding: CGFloat = 6
    private let groupViewPadding: CGFloat = 10
    

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [groupLabel, groupImageView].forEach {groupView.addSubview($0)}
        addSubview(groupView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Handlers
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        setupSublayers()
    }
    
    func setupLayouts() {
        groupView.pin
            .horizontally(50)
            .vertically(groupViewPadding)
        
        groupImageView.pin
            .left(20).vCenter()
            .size(groupView.frame.height - imagePadding * 2)
        
        groupLabel.pin
            .after(of: groupImageView, aligned: .center)
            .marginLeft(20)
            .sizeToFit()
    }
    
    func setupSublayers() {
        configureGroupView()
        configureGroupLabel()
        configureGroupImageView()
    }
    
    
    func configureGroupView() {
        groupView.layer.cornerRadius = self.frame.height / 2.6
        groupView.backgroundColor = .accentColor
        groupView.insertBackLayer()
        groupView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 1, cornerRadius: groupView.layer.cornerRadius)
        groupView.addOneMoreShadow(color: .black, alpha: 0.15, x: -1, y: 1, blur: 1, cornerRadius: groupView.layer.cornerRadius)
        
        
//        groupView.layer.shadowOffset = CGSize(width: 0, height: 0)
//        groupView.layer.shadowRadius = 10
//        groupView.layer.shadowOpacity = 0.3
    }
    
    func configureGroupLabel() {
        groupLabel.textColor = .darkTextColor
        groupLabel.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    func configureGroupImageView() {
        groupImageView.layer.cornerRadius = (self.frame.height - (imagePadding + groupViewPadding) * 2) / 2
        groupImageView.layer.masksToBounds = false
        groupImageView.clipsToBounds = true
    }
    
    
    func setUp(group: Group) {
        groupLabel.text = group.name
        groupImageView.image = UIImage(named: group.image)
    }
    
}
