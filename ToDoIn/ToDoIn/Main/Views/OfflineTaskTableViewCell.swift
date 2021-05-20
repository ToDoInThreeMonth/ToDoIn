import UIKit

final class OfflineTaskTableViewCell: TaskTableViewCell {
    weak var delegate: MainTableViewOutput?
    var index: IndexPath?
    
    private lazy var dimmingView = UIView()
    private lazy var tapDoneViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(doneViewTapped))
    private var panGesture = UIPanGestureRecognizer(target: self, action: #selector(cellDragged(gesture:)))
    private var longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        cellDraggConfigure()
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
    
    func setUp(with task: OfflineTask) {
        taskLabel.text = task.title
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
        isDoneView.backgroundColor = .systemBlue
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
    
    private func cellDraggConfigure() {
        isDoneView.addGestureRecognizer(longTap)
//        taskView.isUserInteractionEnabled = true
        isDoneView.addGestureRecognizer(panGesture)
        
        panGesture.delegate = self
    }
    
    @objc
    private func longTapped() {
        print("вова = пидор")
//        guard let index = index else {
//            return
//        }
//        delegate?.cellDidSelect(in: index)
    }
    
    @objc
    private func cellDragged(gesture: UIPanGestureRecognizer) {
//        guard let index = index else {
//            return
//        }
//        delegate?.cellDidSelect(in: index)
        print("Вызвал")
//        guard let viewController = delegate as? UIViewController else { return }
//        let view = viewController.view
//        let translation = gesture.translation(in: view)
//
//        dimmingView.center.x = translation.x
    }
    
}

