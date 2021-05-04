import UIKit

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "TaskCell"
    
    var taskView = UIView()
    var taskLabel = UILabel()
    var isDoneView = UIView()
    
    private let taskViewPadding: CGFloat = 5
    private let isDoneViewPadding: CGFloat = 5

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        taskView.addSubviews(taskLabel, isDoneView)
        addSubview(taskView)
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
    
    func setupSublayers() {
        configureTaskView()
        configureTaskLabel()
        configureIsDoneView()
    }
    
    
    func configureTaskView() {
        taskView.backgroundColor = .accentColor
        if taskView.layer.cornerRadius == 0 {
            taskView.layer.cornerRadius = self.frame.height / 2.6
            taskView.addShadow(type: .outside, color: .white, power: 1, alpha: 0.8, offset: -0.5)
            taskView.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
            taskView.addLinearGradiend()
        }
    }
    
    func configureTaskLabel() {
        taskLabel.font = UIFont(name: "Inter-Regular", size: 12)
        taskLabel.textColor = .darkTextColor
    }
    
    
    func configureIsDoneView() {
        isDoneView.backgroundColor = .accentColor
        if isDoneView.layer.cornerRadius == 0 {
            isDoneView.layer.cornerRadius = (self.frame.height - (isDoneViewPadding + taskViewPadding) * 2) / 2
            isDoneView.addShadow(side: .topLeft, type: .innearRadial, power: 0.3, alpha: 0.3, offset: 3)
            isDoneView.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.5, alpha: 1, offset: 4)
            isDoneView.addShadow(type: .outside, power: 4, alpha: 0.15, offset: 1)
            isDoneView.addShadow(type: .outside, color: .white, power: 4, alpha: 1, offset: -1)
        }
    }
    
    
    func setUp(task: Task?) {
        taskLabel.text = task?.name
    }
    
}
