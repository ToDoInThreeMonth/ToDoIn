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

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [groupLabel, groupImageView].forEach {groupView.addSubview($0)}
        addSubview(groupView)
        
        configureGroupView()
        configureGroupLabel()
        configureGroupImageView()
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        [groupLabel, groupImageView].forEach { groupView.addSubview($0)}
//        addSubview(groupView)
//
//        configureGroupView()
//        configureGroupLabel()
//        configureGroupImageView()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        groupView.pin
            .horizontally(30)
            .vertically(10)
        
        groupImageView.pin
            .left(20).vCenter()
            .size(groupView.frame.height - 20)
        
        groupLabel.pin
            .after(of: groupImageView, aligned: .center)
            .marginLeft(20)
            .sizeToFit()
    }
    
    func setUp(group: Group) {
        groupLabel.text = group.name
        groupImageView.image = UIImage(named: group.image)
    }
    
    func configureGroupView() {
        groupView.layer.cornerRadius = self.frame.height / 2.5
        groupView.backgroundColor = .darkAccentColor
        groupView.layer.shadowOffset = CGSize(width: 0, height: 0)
        groupView.layer.shadowRadius = 10
        groupView.layer.shadowOpacity = 0.3
    }
    
    func configureGroupLabel() {
        groupLabel.textColor = .darkTextColor
        groupLabel.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    func configureGroupImageView() {
        groupImageView.layer.cornerRadius = 25
        groupImageView.clipsToBounds = true
    }
    
}
