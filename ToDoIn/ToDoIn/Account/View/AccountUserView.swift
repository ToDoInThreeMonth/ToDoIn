import UIKit
import PinLayout

final class AccountUserView: UIView {
    private var imageView: UIImageView
    
    init(image: UIImage?, frame: CGRect) {
        imageView = UIImageView(image: image)
        super.init(frame: frame)
        setupView()
        setupImageView()
        setupLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupImageView() {
        imageView.backgroundColor = .white
    }
    
    private func setupView() {
        addSubview(imageView)
    }
    
    private func setupLayouts() {
        imageView.pin.center()
        imageView.pin.size(CGSize(width: 100, height: 100))
    }
    
    func changeImage(to image: UIImage?) {
        imageView.image = image
    }
}
