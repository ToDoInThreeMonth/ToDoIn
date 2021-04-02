//
//  GroupCell.swift
//  ToDoIn
//
//  Created by Дарья on 02.04.2021.
//

import UIKit

class GroupCell: UITableViewCell {
    
    // MARK: - Properties
    
    var groupView = UIView()
    var groupLabel = UILabel()
    var groupImageView = UIImageView()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [groupLabel, groupImageView].forEach { groupView.addSubview($0)}
        addSubview(groupView)
        
        configureGroupView()
        configureGroupLabel()
        configureGroupImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        groupView.pin
            .horizontally(30)
            .vertically(20)
        
        groupImageView.pin
            .left(20).vCenter()
            .size(50)
        
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
        groupView.layer.cornerRadius = 30
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
