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
    var section: Int?
    
    private lazy var taskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "addTask")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(taskButtonTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private lazy var deleteSectionButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "deleteSection")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(deleteSectionTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return button
    }()
    
    struct LayoutConstraints {
        static let end: CGFloat = 35
        static let taskSize = CGSize(width: 25, height: 26)
        static let sumTaskWidth: CGFloat = taskSize.width + end
        static let deleteSize = CGSize(width: 15, height: 15)
    }
    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView(frame: .zero)
//        stackView.axis = .horizontal
//        stackView.spacing = 9
//        stackView.alignment = .center
//        return stackView
//    }()
    
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
//        stackView.addArrangedSubview(deleteSectionButton)
//        stackView.addArrangedSubview(sectionNameLabel)
        contentView.addSubviews(taskButton, sectionNameLabel, deleteSectionButton)
    }
    
    private func setupLayouts() {
        taskButton.pin
            .top(5)
            .end(35)
            .size(CGSize(width: 25, height: 26))
        sectionNameLabel.pin
            .center()
            .maxWidth(bounds.width - 2 * LayoutConstraints.sumTaskWidth)
            .sizeToFit()
        deleteSectionButton.pin
            .end(to: sectionNameLabel.edge.start)
            .vCenter()
            .size(LayoutConstraints.deleteSize)
            .marginEnd(9)
        
    }
    
    @objc
    private func taskButtonTapped() {
        guard let section = section else { return }
        delegate?.showAddTaskController(with: section)
    }
    
    @objc
    private func deleteSectionTapped() {
        guard let section = section else { return }
        delegate?.deleteSection(section)
    }
    
}
