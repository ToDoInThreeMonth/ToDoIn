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
        taskView.layer.cornerRadius = self.frame.height / 2.6
        guard let sublayersCount = taskView.layer.sublayers?.count else {
            return
        }
        if sublayersCount <= 3 {
            taskView.addBackgroundGradient(UIColor.white.cgColor, UIColor.accentColor.cgColor)
            taskView.addShadow(side: .topCenter, type: .outside, color: .black, power: 3, alpha: 0.1, offset: 0)
        }
    }
    
    func configureTaskLabel() {
        taskLabel.font = UIFont(name: "Inter-Regular", size: 12)
        taskLabel.textColor = .darkTextColor
    }
    
    
    func configureIsDoneView() {
        isDoneView.layer.cornerRadius = (self.frame.height - (isDoneViewPadding + taskViewPadding) * 2) / 2
        isDoneView.backgroundColor = .accentColor
        isDoneView.addShadow(side: .bottomRight, type: .innearRadial, color: .black, power: 0.2, alpha: 0.05, offset: 0)
    }
    
    
    func setUp(task: Task?) {
        taskLabel.text = task?.name
    }
    
}

