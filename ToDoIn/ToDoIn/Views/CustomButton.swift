import UIKit

class CustomButton: UIButton {
    
    struct LayersConstants {
        static let buttonWidth: CGFloat = UIScreen.main.bounds.width - 80
        static let buttonHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 15
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: LayersConstants.buttonWidth, height: LayersConstants.buttonHeight))
        setTitleColor(.darkTextColor, for: .normal)
        layer.cornerRadius = LayersConstants.cornerRadius
        
        setBackground()
        setShadows()
    }

    init(with title: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: LayersConstants.buttonWidth, height: LayersConstants.buttonHeight))
        setTitle(title, for: .normal)
        setTitleColor(.darkTextColor, for: .normal)
        layer.cornerRadius = LayersConstants.cornerRadius
        
        setBackground()
        setShadows()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        setTitle(title, for: .normal)
    }
    
    func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: LayersConstants.buttonWidth, height: LayersConstants.buttonHeight)
        gradientLayer.cornerRadius = LayersConstants.cornerRadius
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.accentColor.cgColor]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setShadows() {
        addShadow(type: .outside, color: .white, power: 1, alpha: 1, offset: -1)
        addShadow(type: .outside, power: 1, alpha: 0.15, offset: 1)
    }
    
}
