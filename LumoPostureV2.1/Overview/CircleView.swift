//
//  CircleView.swift
//  LumoPostureV2.1
//
//  Created by Emil Selin on 4/18/18.
//  Copyright © 2018 com. All rights reserved.
//
//  code from: https://stackoverflow.com/questions/26578023/animate-drawing-of-a-circle?rq=1

import UIKit

class CircleView: UIView {
    var circleLayer: CAShapeLayer!
    var currentValue: CGFloat = 0.0
    
    init(frame: CGRect, color: UIColor, width: CGFloat) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        // Use UIBezierPath as an easy way to create the CGPath for the layer.
        // The path should be the entire circle.
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: (frame.size.width - width)/2, startAngle: -.pi/2, endAngle: .pi * 2.0 - .pi/2, clockwise: true)
        
        // Setup the CAShapeLayer with the path, colors, and line width
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = color.cgColor
        circleLayer.lineWidth = width
        
        // Don't draw the circle initially
        circleLayer.strokeEnd = currentValue
        
        // Add the circleLayer to the view's layer's sublayers
        layer.addSublayer(circleLayer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateCircle(newValue: CGFloat, duration: TimeInterval) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        // Set the animation duration appropriately
        animation.duration = duration
        
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = currentValue
        animation.toValue = newValue
        
        // Do a linear animation (i.e. the speed of the animation stays the same)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = newValue
        
        // Do the actual animation
        circleLayer.add(animation, forKey: "animateCircle")
        currentValue = newValue
    }
}
