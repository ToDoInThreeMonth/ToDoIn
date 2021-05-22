import UIKit

class GradientProgressView: UIProgressView {
    private var leftColor: UIColor
    private var rightColor: UIColor
    
    init(leftColor: UIColor, rightColor: UIColor) {
        self.leftColor = leftColor
        self.rightColor = rightColor
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
    }
}
