import UIKit

extension UIView {
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
    
    enum TypeShadow {
        case single
        case outside
        case innearRadial
        case innearLinear
    }
    
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
    
    /**
     Это универсальный метод добавления тени. В зависимости от параметров можно добавить обычную/множественную внешнюю/внутреннюю тень
     - Parameter side: Указатель смещения тени. 9 направлений для innearLinear. Для innearRadial 4 направления в разные углы. Не влияет на другие виды тени.
     - Parameter type: Указатель на вид тени. single - обычная тень без подслоев. outside - внешняя множественная тень. innear - внутренняя тень
     - Parameter color: Цвет тени.
     - Parameter power: для внутренней тени в диапазоне от 0 до 1. Для других от 0. Задает силу размытия. Для любой внешней тени = 10. Для внутренней = 1 (по умолчанию)
     - Parameter alpha: Прозрачность тени.
     - Parameter offset: Смещение тени. Для линейной множественной тени можно выбрать 9 через side направлений смещения. Для других теней положительное значение смещает в нижний правый угол, отрицательное - в верхний левый.
     */
    func addShadow(side: SidesBlur = .bottomRight,
                   type: TypeShadow = .single,
                   color: UIColor = UIColor.black,
                   power: Float = 10,
                   alpha: Float = 0.1,
                   offset: CGFloat = 10) {
        // Тень на корневой слой View
        if type == .single {
            layer.shadowColor = color.cgColor
            layer.shadowOffset = CGSize(width: offset, height: offset)
            layer.shadowRadius = CGFloat(power)
            layer.shadowOpacity = alpha
        }
        
        // Внутренняя тень
        if type == .innearLinear || type == .innearRadial {
            /// Ограничение на размытие
            var powerBlur: Float = 1.0
            switch power {
            case ..<0:
                powerBlur = 0
            case 0...1:
                powerBlur = power
            default:
                powerBlur = 1
            }
            /// Слой - родитель, по которому будет обрезаться внутренняя тень
            let superLayer = CALayer()
            superLayer.frame = bounds
            superLayer.cornerRadius = layer.cornerRadius
            superLayer.masksToBounds = true
            layer.addSublayer(superLayer)
            // Внутренняя тень
            let gradientLayer = CAGradientLayer()
            gradientLayer.opacity = alpha
            superLayer.addSublayer(gradientLayer)
            
            guard type == .innearRadial else {
                /// Выбор направления линейной тени
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
                /// Настройка линейной тени
                gradientLayer.name = "linearShadow"
                gradientLayer.colors = [color.cgColor, UIColor.white.withAlphaComponent(0), UIColor.white.withAlphaComponent(0), UIColor.white.withAlphaComponent(0)]
                gradientLayer.locations = [0, NSNumber(value: powerBlur), NSNumber(value: 1 - powerBlur), 1]
                gradientLayer.cornerRadius = layer.cornerRadius
                return
            }
            /// Выбор стороны смещения радиальной тени
            switch side {
            case .topLeft:
                gradientLayer.frame = CGRect(x: bounds.minX - offset / 10,
                                             y: bounds.minY - offset / 10,
                                             width: bounds.width + offset,
                                             height: bounds.height + offset)
            case .bottomRight:
                gradientLayer.frame = CGRect(x: bounds.minX - offset * (1 - 1 / 10),
                                             y: bounds.minY - offset * (1 - 1 / 10),
                                             width: bounds.width + offset,
                                             height: bounds.height + offset)
            case .bottomLeft:
                gradientLayer.frame = CGRect(x: bounds.minX - offset / 10,
                                             y: bounds.minY - offset * (1 - 1 / 10),
                                             width: bounds.width + offset,
                                             height: bounds.height + offset)
            case .topRight:
                gradientLayer.frame = CGRect(x: bounds.minX - offset * (1 - 1 / 10),
                                             y: bounds.minY - offset * 1 / 10,
                                             width: bounds.width + offset,
                                             height: bounds.height + offset)
            default:
                gradientLayer.frame = bounds
            }
            // Настройка радиальной тени
            gradientLayer.type = .radial
            gradientLayer.name = "radialShadow"
            gradientLayer.colors = [
                UIColor.white.withAlphaComponent(0).cgColor,
                UIColor.white.withAlphaComponent(0).cgColor,
                color.cgColor
            ]
            
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.locations = [0, NSNumber(value: 1 - powerBlur), 1]
            return
        }
        
        // Внешняя множественная тень
        var isHaveBackground = false
        /// Проверяем, добавлен слой, замещающий фон
        layer.sublayers?.forEach {
            if $0.name == "background" { isHaveBackground = true }
        }
        /// Добавляем фоновый слой
        if !isHaveBackground {
            let oldLayer = CALayer()
            oldLayer.name = "background"
            oldLayer.backgroundColor = backgroundColor?.cgColor
            oldLayer.cornerRadius = layer.cornerRadius
            oldLayer.frame = layer.bounds
            oldLayer.masksToBounds = false
            layer.insertSublayer(oldLayer, at: 0)
        }
    
        let outsideShadowLayer = CALayer()
        /// Настройка внешней тени
        outsideShadowLayer.name = "outsideShadow"
        outsideShadowLayer.shadowColor = color.cgColor
        outsideShadowLayer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        outsideShadowLayer.shadowOffset = CGSize(width: offset, height: offset)
        outsideShadowLayer.shadowRadius = CGFloat(power)
        outsideShadowLayer.shadowOpacity = alpha
        
        layer.insertSublayer(outsideShadowLayer, at: 0)
    }
    
    func addLinearGradiend() {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.5)
            gradient.frame = bounds
            gradient.cornerRadius = layer.cornerRadius
            gradient.locations = [0, 1]
            layer.addSublayer(gradient)
    }
}
