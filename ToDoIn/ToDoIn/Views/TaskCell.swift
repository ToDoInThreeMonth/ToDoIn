import UIKit

class TaskCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "TaskCell"
    
    var taskView = UIView()
    var taskLabel = UILabel()
    var isDoneView = UIView()
    
    
    private let taskViewPadding: CGFloat = 5
    private let isDoneViewPadding: CGFloat = 5
    

    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        // градиент
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = taskView.bounds
        gradientLayer.cornerRadius = taskView.layer.cornerRadius
        gradientLayer.colors = [ UIColor.white.cgColor, UIColor.accentColor.cgColor ]
        taskView.layer.insertSublayer(gradientLayer, at: 0)
        
        taskView.insertBackLayer()
        taskView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 1, cornerRadius: taskView.layer.cornerRadius)
        taskView.addOneMoreShadow(color: .black, alpha: 0.15, x: -1, y: 1, blur: 1, cornerRadius: taskView.layer.cornerRadius)
    }
    
    func configureTaskLabel() {
        taskLabel.font = UIFont(name: "Inter-Regular", size: 12)
        taskLabel.textColor = .darkTextColor
    }
    
    
    func configureIsDoneView() {
        isDoneView.layer.cornerRadius = (self.frame.height - (isDoneViewPadding + taskViewPadding) * 2) / 2
        isDoneView.backgroundColor = .accentColor
        isDoneView.insertBackLayer()
        isDoneView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 1, cornerRadius: isDoneView.layer.cornerRadius)
        isDoneView.addOneMoreShadow(color: .black, alpha: 0.15, x: -1, y: 1, blur: 1, cornerRadius: isDoneView.layer.cornerRadius)
    }
    
    
    func setUp(task: Task) {
        taskLabel.text = task.name
    }
    
}

