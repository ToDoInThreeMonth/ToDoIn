import UIKit

final class OfflineTaskTableViewCell: TaskTableViewCell {
    private lazy var dimmingView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        configureDimmingView()
    }
    
    private func setupViews() {
        taskView.insertSubview(dimmingView, at: 0)
    }
    
    func setUp(with task: Task) {
        taskLabel.text = task.name
    }
    
    private func configureDimmingView() {
        if dimmingView.layer.cornerRadius == 0 {
            dimmingView.backgroundColor = .clear
            dimmingView.layer.cornerRadius = taskView.layer.cornerRadius
        }
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        dimmingView.pin
            .all()
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: true)
        if highlighted {
            dimmingView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        } else {
            dimmingView.backgroundColor = .clear
        }
    }
}

