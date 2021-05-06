//
//  MainOfflineHeaderView.swift
//  ToDoIn
//
//  Created by Tsar on 12.04.2021.
//

import UIKit
import PinLayout

class MainOfflineHeaderView: UITableViewHeaderFooterView {
    var sectionName: String? {
        didSet {
            guard let safeName = sectionName else { return }
            sectionNameLabel.text = safeName
        }
    }
    
    weak var delegate: MainTableViewOutput?
    
    private lazy var taskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "addTask")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(taskButtonTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var sectionNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = ""
        label.textAlignment = .center
        label.textColor = .darkTextColor
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        return CGSize(width: contentView.frame.width, height: 40)
    }
    
    private func setupViews() {
        contentView.addSubviews(taskButton, sectionNameLabel)
    }
    
    private func setupLayouts() {
        taskButton.pin
            .top(5)
            .end(35)
            .size(CGSize(width: 25, height: 26))
        sectionNameLabel.pin
            .vCenter()
            .horizontally(40)
            .sizeToFit(.width)
        
    }
    
    @objc
    private func taskButtonTapped() {
        delegate?.addTaskButtonTapped()
    }
    
}
