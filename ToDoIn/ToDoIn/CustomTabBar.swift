//
//  TabBarViewController.swift
//  ToDoIn
//
//  Created by Дарья on 26.03.2021.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        return CGSize(width: size.width, height: size.height + 50)
//    }
    
    private func addShape(_ rect: CGRect) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createNewPath(rect)
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.tabBarColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        shapeLayer.shadowColor = UIColor.white.cgColor
        shapeLayer.shadowOffset = CGSize(width: 1, height: 1)
        shapeLayer.shadowRadius = 1
        shapeLayer.shadowOpacity = 1
        
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOffset = CGSize(width: 0, height: -1)
        shapeLayer.shadowRadius = 1
        shapeLayer.shadowOpacity = 0.15
        
//        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
//        shapeLayer.shadowRadius = 7
//        shapeLayer.fillColor = UIColor.tabBarColor.cgColor
//        shapeLayer.shadowOpacity = 0.2
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    override func draw(_ rect: CGRect) {
        self.addShape(rect)
        self.unselectedItemTintColor = UIColor.lightTextColor
        self.tintColor = UIColor.darkTextColor
    }

    func createNewPath(_ rect: CGRect) -> CGPath {
        let path = UIBezierPath()
        let screenCenter = rect.width / 2
        let mainRadius: CGFloat = 40
        let radius: CGFloat = 20
        let angle: CGFloat = CGFloat.pi * 10 / 180 // угол 10 градусов
        let yArcCenter = cos(CGFloat.pi / 2 - angle) * mainRadius
        let minRadius = sin(CGFloat.pi / 2 - angle) * mainRadius
        let startAngle: CGFloat = -angle
        let endAngle: CGFloat = -CGFloat.pi + angle
        
        path.move(to: CGPoint(x: 0, y: radius))
        path.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -CGFloat.pi, endAngle: -CGFloat.pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: screenCenter - minRadius, y: 0))
        path.addArc(withCenter: CGPoint(x: screenCenter, y: yArcCenter), radius: mainRadius, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.addLine(to: CGPoint(x: screenCenter + minRadius, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width - radius, y: 0))
        path.addArc(withCenter: CGPoint(x: self.frame.width - radius, y: radius), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: .zero, clockwise: true)
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
        
    }
}
