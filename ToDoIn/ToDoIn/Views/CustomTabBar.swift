import UIKit

final class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?
    
    struct LayersConstants {
        static let centerArcRadius: CGFloat = 40
        static let sideArcRadius: CGFloat = 20
        static let centerArcWidth = sin(CGFloat.pi / 2 - angle) * centerArcRadius
        static let yCenterArc = cos(CGFloat.pi / 2 - angle) * LayersConstants.centerArcRadius
        static let angle: CGFloat = CGFloat.pi * 10 / 180
        static let startAngle: CGFloat = -angle
        static let endAngle: CGFloat = -CGFloat.pi + angle
    }
    
    private func addShape(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createNewPath(rect)
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.accentColor.cgColor
        shapeLayer.lineWidth = 1.0

        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: -1)
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 0.10
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addShape(rect)
        self.unselectedItemTintColor = UIColor.lightTextColor
        self.tintColor = UIColor.darkTextColor
    }

    func createNewPath(_ rect: CGRect) -> CGPath {
        let path = UIBezierPath()
        let screenCenter = rect.width / 2
        
        let leftArcStartPoint = CGPoint(x: 0, y: LayersConstants.sideArcRadius)
        let leftArcCenterPoint = CGPoint(x: LayersConstants.sideArcRadius, y: LayersConstants.sideArcRadius)
        let rightArcStartPoint = CGPoint(x: self.frame.width - LayersConstants.sideArcRadius, y: 0)
        let rightArcCenterPoint = CGPoint(x: self.frame.width - LayersConstants.sideArcRadius, y: LayersConstants.sideArcRadius)
        let centerArcStartPoint = CGPoint(x: screenCenter - LayersConstants.centerArcWidth, y: 0)
        let centerArcCenterPoint = CGPoint(x: screenCenter, y: LayersConstants.yCenterArc)
        let centerArcEndPoint = CGPoint(x: screenCenter + LayersConstants.centerArcWidth, y: 0)
        
        path.move(to: leftArcStartPoint)
        path.addArc(withCenter: leftArcCenterPoint, radius: LayersConstants.sideArcRadius, startAngle: -CGFloat.pi, endAngle: -CGFloat.pi / 2, clockwise: true)
        path.addLine(to: centerArcStartPoint)
        path.addArc(withCenter: centerArcCenterPoint, radius: LayersConstants.centerArcRadius, startAngle: LayersConstants.endAngle, endAngle: LayersConstants.startAngle, clockwise: true)
        path.addLine(to: centerArcEndPoint)
        path.addLine(to: rightArcStartPoint)
        path.addArc(withCenter: rightArcCenterPoint, radius: LayersConstants.sideArcRadius, startAngle: -CGFloat.pi / 2, endAngle: .zero, clockwise: true)
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
        
    }
}
