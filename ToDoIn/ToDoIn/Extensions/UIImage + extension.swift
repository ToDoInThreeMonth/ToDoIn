import UIKit

extension UIImage {
    
    static func gradientImage(with bounds: CGRect,
                              colors: [CGColor]) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
