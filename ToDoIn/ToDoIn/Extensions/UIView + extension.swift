import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    func makeRound() {
        layer.cornerRadius = bounds.width / 2
    }
    
    func insertBackLayer() {
        let oldLayer = CALayer()
        oldLayer.backgroundColor = backgroundColor?.cgColor
        oldLayer.cornerRadius = layer.cornerRadius
        oldLayer.frame = layer.bounds
        oldLayer.masksToBounds = false
        layer.insertSublayer(oldLayer, at: 0)
    }
    /// Если используются только обычные тени, без внутренних, то обязательно сначала нужно вызвать метод insertBackLayer
    func setShadowWithColor(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, cornerRadius: CGFloat = 0) {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.shadowOffset = CGSize(width: x, height: y)
        shadowLayer.shadowRadius = blur
        shadowLayer.shadowOpacity = alpha
     
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    /// Добавляет внутреннюю тень на View. Нельзя совмещать на одном view методы setShadowWithColor и addInnerShadowWithColor.
    /// Данный метод, в случае с использованием обычных теней, применяется к отдельному View, который находится строго поверх View с обычными тенями.
    /// Также, в случае с использованием обычных теней, можно не применять к нижнему View метод insertBackLayer
    func addInnerShadowWithColor(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, cornerRadius: CGFloat = 0) {
        let shadowLayer = CALayer()
        let rect = CGRect(x: bounds.minX + x,
                          y: bounds.minY + y,
                          width: bounds.width,
                          height: bounds.height)
        
        let normalPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        let maskPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        normalPath.append(maskPath.reversing())
        shadowLayer.shadowRadius = blur
        shadowLayer.shadowPath = normalPath.cgPath
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowOpacity = alpha
        layer.insertSublayer(shadowLayer, at: 0)
        layer.masksToBounds = true
    }
}
