//
//  CustomTabBar.swift
//  JetLiveStream
//
//  Created by Ashish Khobragade on 28/09/20.
//  Copyright © 2020 Ashish Khobragade. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    private var shapeLayer: CALayer?

    override func draw(_ rect: CGRect) {
        self.addShape()
    }

    private func addShape() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 10
        shapeLayer.shadowColor = UIColor.gray.cgColor
        shapeLayer.shadowOpacity = 0.3

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

//    func createPath() -> CGPath {
//        let height: CGFloat = 86.0
//        let path = UIBezierPath()
//        let centerWidth = self.frame.width / 2
//        path.move(to: CGPoint(x: 0, y: -30))
//
//        path.addCurve(to: CGPoint(x: (centerWidth - height), y: 0),
//                      controlPoint1: CGPoint(x:15, y: 0),
//                      controlPoint2: CGPoint(x:30, y: 0)) //left end curve
//        
//        path.addLine(to: CGPoint(x: (centerWidth - height), y: 0))
//
//        path.addCurve(to: CGPoint(x: centerWidth, y: height - 40),
//                      controlPoint1: CGPoint(x: (centerWidth - 30), y: 0),
//                      controlPoint2: CGPoint(x: centerWidth - 35, y: height - 40)) //left central
//        
//        path.addCurve(to: CGPoint(x: (centerWidth + height ), y: 0),
//                      controlPoint1: CGPoint(x: centerWidth + 35, y: height - 40),
//                      controlPoint2: CGPoint(x: (centerWidth + 30), y: 0)) //right central
//        
//        path.addCurve(to: CGPoint(x:self.frame.width , y: -30),
//                      controlPoint1: CGPoint(x: self.frame.width - 30 , y: 0),
//                      controlPoint2: CGPoint(x:  self.frame.width - 15, y: 0))//right end curve
//        
//        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
//        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
//        path.close()
//        return path.cgPath
//    }
    func createPath() -> CGPath {
        let cornerRadius: CGFloat = 30.0 // Adjust as needed for your corner radius
        let path = UIBezierPath()
        let width = self.frame.width
        let height = self.frame.height
        
        // Start from top left with a rounded corner
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0),
                          controlPoint: CGPoint(x: 0, y: 0)) // Top-left rounded corner
        
        // Line to top right before the rounded corner
        path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        
        // Top-right rounded corner
        path.addQuadCurve(to: CGPoint(x: width, y: cornerRadius),
                          controlPoint: CGPoint(x: width, y: 0)) // Top-right rounded corner
        
        // Line to bottom right
        path.addLine(to: CGPoint(x: width, y: height))
        
        // Line to bottom left
        path.addLine(to: CGPoint(x: 0, y: height))
        
        // Close the path
        path.close()
        
        return path.cgPath
    }


    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }
}

extension UITabBar {
//    override open func sizeThatFits(_ size: CGSize) -> CGSize {
//        var sizeThatFits = super.sizeThatFits(size)
//        sizeThatFits.height = 74
//        return sizeThatFits
//    }
}
