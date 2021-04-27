import UIKit
import PinLayout

class MainOfflineHeaderView: UITableViewHeaderFooterView {
    
    weak var mainViewController: MainView?
    
    private var section: Section?
    
    lazy var taskButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "addTask")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
            .end(20)
            .size(CGSize(width: 25, height: 26))
        sectionNameLabel.pin
            .vCenter()
            .horizontally(20)
            .sizeToFit(.width)
        
    }
    
    func setSectionLabel(with section: Section) {
        self.section = section
        sectionNameLabel.text = section.name
    }
    
    @objc
    func addButtonTapped() {
        mainViewController?.addTaskButtonTapped(section: section ?? Section())
    }
    
}
