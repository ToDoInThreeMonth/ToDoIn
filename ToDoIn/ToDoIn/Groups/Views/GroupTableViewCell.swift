import UIKit

final class GroupTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    private weak var controller: GroupsViewProtocol?
    
    static let identifier = "GroupCell"
    
    private let groupView = UIView()
    private let groupLabel = UILabel()
    private let groupImageView = UIImageView(image: UIImage(named: "default"))
    private let dimmingView = UIView()
    
    private let imagePadding: CGFloat = 6
    private let groupViewPadding: CGFloat = 10
    

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        [groupLabel, groupImageView].forEach {groupView.addSubview($0)}
        groupView.insertSubview(dimmingView, at: 0)
        contentView.addSubview(groupView)
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
    
    private func setupLayouts() {
        groupView.pin
            .horizontally(50)
            .vertically(groupViewPadding)
        
        groupImageView.pin
            .right(20).vCenter()
            .size(groupView.frame.height - imagePadding * 2)
        
        groupLabel.pin
            .left(20).vCenter()
            .sizeToFit()
        
        dimmingView.pin.all()
    }
    
    private func setupSublayers() {
        configureGroupView()
        configureDimmingView()
        configureGroupLabel()
        configureGroupImageView()
    }
    
    
    private func configureGroupView() {
        groupView.backgroundColor = .accentColor
        if groupView.layer.cornerRadius == 0 {
            groupView.layer.cornerRadius = self.frame.height / 2.6
            groupView.addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -0.5)
            groupView.addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
            groupView.addLinearGradiend()
        }
    }
    
    private func configureGroupLabel() {
        groupLabel.textColor = .darkTextColor
        groupLabel.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    private func configureGroupImageView() {
        groupImageView.makeRound()
        groupImageView.layer.masksToBounds = false
        groupImageView.clipsToBounds = true
        groupImageView.contentMode = .scaleAspectFill
    }
    
    private func configureDimmingView() {
        dimmingView.backgroundColor = .clear
        dimmingView.layer.cornerRadius = self.frame.height / 2.6
    }
    
    // MARK: - Handlers
    
    func setupController(with controller: GroupsViewProtocol) {
        self.controller = controller
    }
    
    func setUp(group: Group) {
        groupLabel.text = group.title
        if group.image != "default" {
            controller?.loadImage(url: group.image) { [weak self] (image) in
                self?.groupImageView.image = image
            }
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            dimmingView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        } else {
            dimmingView.backgroundColor = .clear
        }
    }
    
}

