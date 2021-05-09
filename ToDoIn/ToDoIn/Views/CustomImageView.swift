import Foundation
import UIKit
import PinLayout

final class CustomImageView: UIView {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "default")
        imageView.backgroundColor = .accentColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        makeRound()
        backgroundColor = .accentColor
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.pin.all().margin(20)
        imageView.makeRound()
        configureShadows()
    }
    
    private func configureShadows() {
        addShadow(side: .bottomRight, type: .outside, alpha: 0.15)
        addShadow(side: .bottomRight, type: .outside, color: .white, alpha: 1, offset: -10)
        addShadow(side: .topLeft, type: .innearRadial, color: .white, power: 0.15, alpha: 1, offset: 10)
        addShadow(side: .bottomRight, type: .innearRadial, power: 0.15, offset: 10)
        
        imageView.addShadow(side: .topLeft, type: .innearRadial, power: 0.1, alpha: 0.3, offset: 10)
        imageView.addShadow(side: .bottomRight, type: .innearRadial, color: .white, power: 0.1, alpha: 0.5, offset: 10)
    }
    
    func setImage(with image: UIImage?) {
        imageView.image = image
    }
    
    func getImage() -> UIImage? {
        imageView.image
    }
}
