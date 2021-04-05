import UIKit

class GroupCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "GroupCell"
    
    var groupView = UIView()
    var groupLabel = UILabel()
    var groupImageView = UIImageView()
    
    var dimmingView = UIView()
    
    private let imagePadding: CGFloat = 6
    private let groupViewPadding: CGFloat = 10
    

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        [groupLabel, groupImageView, dimmingView].forEach {groupView.addSubview($0)}
        addSubview(groupView)
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
        groupView.pin
            .horizontally(50)
            .vertically(groupViewPadding)
        
        groupImageView.pin
            .left(20).vCenter()
            .size(groupView.frame.height - imagePadding * 2)
        
        groupLabel.pin
            .after(of: groupImageView, aligned: .center)
            .marginLeft(20)
            .sizeToFit()
        
        dimmingView.pin
            .horizontally(50)
            .vertically(groupViewPadding)
    }
    
    func setupSublayers() {
        configureGroupView()
        configureDimmingView()
        configureGroupLabel()
        configureGroupImageView()
    }
    
    
    func configureGroupView() {
        groupView.layer.cornerRadius = self.frame.height / 2.6
        
        // градиент на фоне ячейки
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = groupView.bounds
        gradientLayer.cornerRadius = groupView.layer.cornerRadius
        gradientLayer.colors = [ UIColor.white.cgColor, UIColor.accentColor.cgColor ]
        groupView.layer.insertSublayer(gradientLayer, at: 0)
        
        groupView.insertBackLayer()
        groupView.backgroundColor = UIColor(red: 243/255, green: 247/255, blue: 250/255, alpha: 1)
        groupView.addOneMoreShadow(color: .white, alpha: 1, x: -1, y: -1, blur: 1, cornerRadius: groupView.layer.cornerRadius)
        groupView.addOneMoreShadow(color: .black, alpha: 0.15, x: -1, y: 1, blur: 1, cornerRadius: groupView.layer.cornerRadius)
    }
    
    func configureGroupLabel() {
        groupLabel.textColor = .darkTextColor
        groupLabel.font = UIFont(name: "Inter-Regular", size: 25)
    }
    
    func configureGroupImageView() {
        groupImageView.layer.cornerRadius = (self.frame.height - (imagePadding + groupViewPadding) * 2) / 2
        groupImageView.layer.masksToBounds = false
        groupImageView.clipsToBounds = true
    }
    
    func configureDimmingView() {
        dimmingView.frame = groupView.bounds
        dimmingView.backgroundColor = .clear
        dimmingView.layer.cornerRadius = self.frame.height / 2.6
    }
    
    
    func setUp(group: Group) {
        groupLabel.text = group.name
        groupImageView.image = UIImage(named: group.image)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted {
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        } else {
            dimmingView.backgroundColor = .clear
        }
    }
    
}
