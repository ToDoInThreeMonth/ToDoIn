import UIKit

class MainOfflineTableViewCell: UITableViewCell {
    
    private lazy var taskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 243, green: 247, blue: 250, alpha: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white.withAlphaComponent(0)
        selectedBackgroundView = UIView()
        setupViews()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MainOfflineTableViewCell вызвал init?(coder:)")
    }
    
    override func layoutSubviews() {
        setupLayouts()
        
    }
    
    private func setupViews() {
        contentView.addSubviews(taskView)
    }
    
    private func setupLayouts() {
        taskView.pin
            .all(3)
            .height(40)
    }
    
    private func configureViews() {
        if taskView.layer.cornerRadius == 0 {
            taskView.layer.cornerRadius = taskView.bounds.height / 2
            taskView.insertBackLayer()
            taskView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 1, cornerRadius: taskView.layer.cornerRadius)
            taskView.addOneMoreShadow(alpha: 0.15, x: 1, y: 1, blur: 1, cornerRadius: taskView.layer.cornerRadius)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        setupLayouts()
        configureViews()
        return CGSize(width: contentView.frame.width, height: taskView.frame.height + 10)
    }
    
    func cellDidTapped() {
        let selectView = UIView()
        taskView.addSubview(selectView)
        
        selectView.backgroundColor = UIColor.black
        selectView.alpha = 0
        selectView.frame = taskView.frame
        selectView.layer.cornerRadius = taskView.layer.cornerRadius
        
        let timeInterval = 0.2
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0
        alphaAnimation.toValue = 0.4
        alphaAnimation.duration = timeInterval
        selectView.layer.add(alphaAnimation, forKey: nil)
        
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            selectView.removeFromSuperview()
        }
    }
}
