import UIKit

final class OfflineTaskTableViewCell: TaskTableViewCell {
    weak var delegate: MainTableViewOutput?
    var index: IndexPath?
    
    private lazy var dimmingView = UIView()
    private lazy var tapDoneViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(doneViewTapped))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isDoneView.backgroundColor = .clear
        isDoneView.isHidden = false
        isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        configureDimmingView()
    }
    
    private func setupViews() {
        taskView.insertSubview(dimmingView, at: 0)
    }
    
    func setUp(with task: OfflineTask, isArchive: Bool) {
        taskLabel.text = task.title
        if isArchive {
            isDoneView.backgroundColor = UIColor.lightGreenColor.withAlphaComponent(0.5)
        } else {
            isDoneView.backgroundColor = UIColor.lightRedColor
        }
    }
    
    private func configureDimmingView() {
        if dimmingView.layer.cornerRadius == 0 {
            dimmingView.backgroundColor = .clear
            dimmingView.layer.cornerRadius = taskView.layer.cornerRadius
        }
    }
    
    @objc
    private func doneViewTapped() {
        guard let index = index else { return }
        delegate?.doneViewTapped(with: index)
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
    
    override func configureIsDoneView() {
        super.configureIsDoneView()
        isDoneView.addGestureRecognizer(tapDoneViewRecognizer)
    }
    
}
