import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "TaskCell"
    
    private let taskView = UIView()
    private let taskLabel = UILabel()
    let isDoneView = UIView()
    
    
    private let taskViewPadding: CGFloat = 5
    private let isDoneViewPadding: CGFloat = 5
    

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        taskView.addSubviews(taskLabel, isDoneView)
        contentView.addSubview(taskView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        setupSublayers()
    }
    
    // MARK: - Configures
    
    func setupLayouts() {
        taskView.pin
            .horizontally(30)
            .vertically(taskViewPadding)
        
        taskLabel.pin
            .left(20)
            .vCenter()
            .sizeToFit()
        
        isDoneView.pin
            .right(10)
            .vCenter()
            .size(taskView.frame.height - isDoneViewPadding * 2)
    }
    
    private func setupSublayers() {
        configureTaskView()
        configureTaskLabel()
        configureIsDoneView()
    }
    
    
    private func configureTaskView() {
        taskView.backgroundColor = .accentColor
        if taskView.layer.cornerRadius == 0 {
            taskView.layer.cornerRadius = self.frame.height / 2.6
            taskView.addShadow(type: .outside, color: .white, power: 1, alpha: 0.8, offset: -0.5)
            taskView.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
            taskView.addLinearGradiend()
        }
    }
    
    private func configureTaskLabel() {
        taskLabel.font = UIFont(name: "Inter-Regular", size: 12)
        taskLabel.textColor = .darkTextColor
    }
    
    
    func configureIsDoneView() {
        if isDoneView.layer.cornerRadius == 0 {
            isDoneView.layer.cornerRadius = (self.frame.height - (isDoneViewPadding + taskViewPadding) * 2) / 2
        }
    }
    
    // MARK: - Handlers
    
    func setUp(task: Task?) {
        guard let task = task else {
            return
        }
        taskLabel.text = task.title
        isDoneView.backgroundColor = task.isDone ? UIColor.lightGreenColor.withAlphaComponent(0.5) : UIColor.lightRedColor
    }
    
}
