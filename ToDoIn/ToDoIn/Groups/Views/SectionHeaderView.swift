import UIKit

final class SectionHeaderView: UIView {
    
    // MARK: - Properties
    
    static let identifier = "SectionHeaderView"
    
    private let label = UILabel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override functions
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayouts()
        configureLabel()
    }
    
    // MARK: - Configures
    
    private func setupLayouts() {
        label.pin.left(50)
            .bottom(5)
            .sizeToFit()
    }
    
    // MARK: - Handlers
    
    private func configureLabel() {
        label.font = UIFont(name: "Inter-Regular", size: 12)
        label.textColor = .darkTextColor
    }
    
    
    func setUp(owner: String) {
        label.text = owner
    }
        
}
