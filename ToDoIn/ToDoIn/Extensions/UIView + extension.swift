import UIKit

enum SidesBlur {
    case topLeft
    case topCenter
    case topRight
    case leftCenter
    case rightCenter
    case bottomLeft
    case bottomCenter
    case bottomRight
}

extension UIView {
    /// Позволяет добавить subview к указанному View через запятую
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
    /// Делает квадратное View круглым
    func makeRound() {
        layer.cornerRadius = bounds.width / 2
    }
    
    /// Делает слой - подложку с цветом как у View. Нужен для добавления нескольких теней к одному и тому же View.
    func insertBackLayer() {
        let oldLayer = CALayer()
        oldLayer.backgroundColor = backgroundColor?.cgColor
        oldLayer.cornerRadius = layer.cornerRadius
        oldLayer.frame = layer.bounds
        oldLayer.masksToBounds = false
        layer.insertSublayer(oldLayer, at: 0)
    }
    /// Добавляет теневой подслой к указанному View. Обязательно перед первым добавлением вызвать метод insertBackLayer
    func addOneMoreShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, cornerRadius: CGFloat = 0) {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.shadowOffset = CGSize(width: x, height: y)
        shadowLayer.shadowRadius = blur
        shadowLayer.shadowOpacity = alpha
        
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    /// Задает параметры тени у слоя указанного View
    func setupShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur
        layer.shadowOpacity = alpha
    }
    
    /// Добавляет внутреннюю тень с помощью градиента на View.
    /// Можно делать как радиальную, так и обычную тень. В случае обычной тени, параметр isRadial можно не указывать.
    ///
    /// Для обычной тени:
    /// side - сторона тени
    /// Параметр offset влияет только на радиальную тень.
    ///
    /// Для радиальной тени: указываете isRadial: true
    /// Указываете offset - то, куда сдвинуть тень.
    ///
    /// power - длина тени, alpha - прозрачность.
    /// СТРОГО не совмещать с setShadowWithColor
    func addInnerShadow(side: SidesBlur = .topCenter,
                        color1: UIColor = UIColor.black,
                        power: Float = 0.1,
                        alpha: Float = 0.5,
                        isRadial: Bool = false,
                        offset: CGSize = .zero) {
        let gradientLayer = CAGradientLayer()
        layer.insertSublayer(gradientLayer, at: 0)
        let x = offset.width
        let y = offset.height
        
        switch (x, y) {
        case (0..., 0...):
            gradientLayer.frame = CGRect(x: bounds.minX - offset.width / 10,
                                         y: bounds.minY - offset.height / 10,
                                         width: bounds.width + offset.width,
                                         height: bounds.height + offset.height)
        case (..<0, ..<0):
            gradientLayer.frame = CGRect(x: bounds.minX + offset.width * (1 - 1 / 10),
                                         y: bounds.minY + offset.height * (1 - 1 / 10),
                                         width: bounds.width + abs(offset.width),
                                         height: bounds.height + abs(offset.height))
        case (..<0, 0...):
            gradientLayer.frame = CGRect(x: bounds.minX + offset.width * (1 - 1 / 10),
                                         y: bounds.minY + offset.height / 10,
                                         width: bounds.width + abs(offset.width),
                                         height: bounds.height + offset.height)
        case (0..., ..<0):
            gradientLayer.frame = CGRect(x: bounds.minX - offset.width / 10,
                                         y: bounds.minY + offset.height * (1 - 1 / 10),
                                         width: bounds.width + offset.width,
                                         height: bounds.height + abs(offset.height))
        default:
            gradientLayer.frame = bounds
        }
        
        gradientLayer.opacity = alpha
        
        guard isRadial else {
            switch side {
            case .topLeft:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            case .topCenter:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            case .leftCenter:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightCenter:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            case .bottomLeft:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            case .bottomCenter:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            case .bottomRight:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
            
            gradientLayer.colors = [color1.cgColor, (backgroundColor ?? UIColor.clear).cgColor, (backgroundColor ?? UIColor.clear).cgColor, (backgroundColor ?? UIColor.clear).cgColor]
            gradientLayer.locations = [0, NSNumber(value: power), NSNumber(value: 1 - power), 1]
            gradientLayer.cornerRadius = layer.cornerRadius
            return
        }
        gradientLayer.type = .radial
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor,
            color1.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, NSNumber(value: 1 - power), 1]
        layer.masksToBounds = true
    }
    
    /// Добавляет размытый подслой с помощью градиента на View.
    /// Можно делать как радиальное, так и обычное размытие. В случае обычного размытия, параметр isRadial можно не указывать.
    ///
    /// Для обычного размытия: выбираете сторону, где нужно размыть.
    /// Параметр offset влияет только на радиальное размытие.
    ///
    /// Для радиального размытия указываете isRadial: true
    /// Параметр offset указывает куда сдвинуть размытие.
    ///
    /// power - длина размытия, alpha - прозрачность подслоя.
    /// СТРОГО не совмещать с setShadowWithColor на одном View.
    func addBlurLayer(side: SidesBlur = .topCenter,
                      color1: UIColor = UIColor.black,
                      power: Float = 0.1,
                      alpha: Float = 1,
                      isRadial: Bool = false,
                      offset: CGSize = .zero) {
        let gradientLayer = CAGradientLayer()
        layer.insertSublayer(gradientLayer, at: 0)
        
        let x = offset.width
        let y = offset.height
        switch (x, y) {
        case (0..., 0...):
            gradientLayer.frame = CGRect(x: bounds.minX - offset.width / 10,
                                         y: bounds.minY - offset.height / 10,
                                         width: bounds.width + offset.width,
                                         height: bounds.height + offset.height)
        case (..<0, ..<0):
            gradientLayer.frame = CGRect(x: bounds.minX + offset.width * (1 - 1 / 10),
                                         y: bounds.minY + offset.height * (1 - 1 / 10),
                                         width: bounds.width + abs(offset.width),
                                         height: bounds.height + abs(offset.height))
        case (..<0, 0...):
            gradientLayer.frame = CGRect(x: bounds.minX + offset.width * (1 - 1 / 10),
                                         y: bounds.minY + offset.height / 10,
                                         width: bounds.width + abs(offset.width),
                                         height: bounds.height + offset.height)
        case (0..., ..<0):
            gradientLayer.frame = CGRect(x: bounds.minX - offset.width / 10,
                                         y: bounds.minY + offset.height * (1 - 1 / 10),
                                         width: bounds.width + offset.width,
                                         height: bounds.height + abs(offset.height))
        default:
            gradientLayer.frame = bounds
        }
        gradientLayer.opacity = alpha
        
        guard isRadial else {
            switch side {
            case .topLeft:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
            case .topCenter:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            case .leftCenter:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            case .rightCenter:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
            case .bottomLeft:
                gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            case .bottomCenter:
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
            case .bottomRight:
                gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
                gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
            }
            
            gradientLayer.colors = [color1.cgColor, color1.cgColor, (backgroundColor ?? UIColor.clear).cgColor]
            
            gradientLayer.locations = [0, NSNumber(value: 1 - power), 1]
            gradientLayer.cornerRadius = layer.cornerRadius
            return
        }
        gradientLayer.type = .radial
        
        gradientLayer.colors = [
            color1.cgColor,
            color1.cgColor,
            (backgroundColor ?? UIColor.clear).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.locations = [0, NSNumber(value: 1 - power), 1]
        layer.masksToBounds = true
    }
}
