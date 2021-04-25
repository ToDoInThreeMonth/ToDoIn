import UIKit

class MainOfflineTableViewCell: UITableViewCell {
    
    private lazy var taskView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentColor
        return view
    }()
    private lazy var roundView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white.withAlphaComponent(0)
        selectedBackgroundView = UIView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("MainOfflineTableViewCell вызвал init?(coder:)")
    }
    
    private func setupViews() {
        contentView.addSubviews(taskView)
        taskView.addSubview(roundView)
    }
    
    private func setupLayouts() {
        taskView.pin
            .all(8)
            .height(40)
        roundView.pin
            .end(20)
            .vCenter()
            .size(CGSize(width: 30, height: 30))
    }
    
    private func setupShadows() {
        if taskView.layer.cornerRadius == 0 {
            taskView.layer.cornerRadius = taskView.bounds.height / 2
            taskView.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
            taskView.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
            taskView.addLinearGradiend()
            
            roundView.layer.cornerRadius = roundView.frame.height / 2
            roundView.addShadow(side: .topLeft, type: .innearRadial, power: 0.3, alpha: 0.3, offset: 3)
            roundView.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.5, alpha: 1, offset: 4)
            roundView.addShadow(type: .outside, power: 4, alpha: 0.15, offset: 1)
            roundView.addShadow(type: .outside, color: .white, power: 4, alpha: 1, offset: -1)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        setupLayouts()
        setupShadows()
        return CGSize(width: contentView.frame.width, height: taskView.frame.height + 10)
    }
    
    func cellDidTapped() {
        let selectView = UIView()
        taskView.addSubview(selectView)
        
        selectView.backgroundColor = UIColor.black
        selectView.alpha = 0
        selectView.frame = taskView.bounds
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
