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
    
    private lazy var changeSectionButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "changeSection")?.withRenderingMode(.alwaysOriginal)
        button.addTarget(self, action: #selector(changeSectionTapped), for: .touchUpInside)
        button.setImage(image, for: .normal)
        return button
    }()
    
    struct LayoutConstraints {
        static let end: CGFloat = 35
        static let buttonSize = CGSize(width: 25, height: 26)
        static let sumTaskWidth: CGFloat = buttonSize.width + end
    }
    
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
        contentView.addSubviews(taskButton,
                                sectionNameLabel,
                                deleteSectionButton,
                                changeSectionButton)
    }
    
    private func setupLayouts() {
        taskButton.pin
            .top(5)
            .end(35)
            .size(LayoutConstraints.buttonSize)
        sectionNameLabel.pin
            .center()
            .maxWidth(bounds.width - 3 * LayoutConstraints.sumTaskWidth)
            .sizeToFit()
        deleteSectionButton.pin
            .size(LayoutConstraints.buttonSize)
            .start(40)
            .vCenter()
        changeSectionButton.pin
            .end(to: sectionNameLabel.edge.start)
            .size(LayoutConstraints.buttonSize)
            .vCenter()
            .marginEnd(9)
    }
    
    @objc
    private func taskButtonTapped() {
        guard let section = section else { return }
        delegate?.showAddTaskController(with: section)
    }
    
    @objc
    private func changeSectionTapped() {
        guard let section = section else { return }
        delegate?.showChangeSectionController(with: section)
    }
    
    @objc
    private func deleteSectionTapped() {
        guard let section = section else { return }
        delegate?.showDeleteSectionController(section)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        taskButton.isHidden = false
        deleteSectionButton.isHidden = false
        changeSectionButton.isHidden = false
    }
    
    func setupArchiveState() {
        taskButton.isHidden = true
        deleteSectionButton.isHidden = true
        changeSectionButton.isHidden = true
    }
}
