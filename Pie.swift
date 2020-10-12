//
//  File.swift
//  AniCheck
//
//  Created by Бакулин Семен Александрович on 11.10.2020.
//  Copyright © 2020 Бакулин Семен Александрович. All rights reserved.
//

import UIKit

final class Pie{
    //MARK: -Animation
    
    public lazy var springAnim: (Double)->CASpringAnimation = { delay in
        let anim = CASpringAnimation(keyPath: "transform")
        anim.damping = 14
        anim.initialVelocity = 5
        anim.mass = 2
        anim.stiffness = 80
        anim.duration = anim.settlingDuration
        
        anim.fromValue = CATransform3DMakeScale(0.1, 0.1, 0.1)
        anim.fillMode = .both
        anim.beginTime = CACurrentMediaTime() + delay
        return anim
    }
    
    //MARK: -Properties
    
    public let radius: CGFloat
    
    public let startPoint: CGPoint
    
    private let colors:[UIColor] = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1),#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1),#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)]
    
    public var startAngle: CGFloat = .pi / 2
    
    private var data = [CGFloat](arrayLiteral: 10, 35, 15, 16, 8,7,9)
    
    public var total: CGFloat{
        self.data.reduce(0) { (start, elem) -> CGFloat in
            var start = start
            start += elem
            return start
        }
    }
    
    //MARK: -translate data
    
    public func getPercentage(index:Int)->CGFloat{
        return (self.data[index] / self.total)
    }
    
    private func countEndAngle(index:Int)->CGFloat{
        
        let endAngle = startAngle + getPercentage(index: index) * 2 * .pi
        return endAngle
    }
    
    private func increaseStartAngle(newStartAngle:CGFloat){
        self.startAngle = newStartAngle
    }
    
    //MARK: - create Shapes
    
    private func createTextLayer(center:CGPoint,index:Int,startAngle:CGFloat,endAngle:CGFloat)->CATextLayer{
        let textLayer = CATextLayer()
        textLayer.frame.size = CGSize(width: 25, height: 100)
        textLayer.position = CGPoint(x: center.x, y: center.y)
        textLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        textLayer.alignmentMode = .center
        
        textLayer.fontSize = 20
        textLayer.foregroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        textLayer.string = String(Int(data[index]))
        
        let mediumAngle = ((endAngle + startAngle) / 2) + (90 * .pi / 180)
        
        print(mediumAngle)
        
        textLayer.transform = CATransform3DMakeRotation(mediumAngle, 0, 0, 1)
        
        return textLayer
    }
    
    public func createShapes(view:UIView)->([CAShapeLayer]){
        var shapes = [CAShapeLayer]()
        
        for (index,_) in data.enumerated(){
            
            let shape = CAShapeLayer()
            shape.frame = view.bounds
            
            shape.fillColor = self.colors[index].cgColor
            
            let endAngle = countEndAngle(index: index)
            let path = UIBezierPath(arcCenter: view.center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: view.center)
            
            shape.path = path.cgPath
            
            shape.addSublayer(createTextLayer(center: view.center, index: index, startAngle: startAngle, endAngle: endAngle))
            
            increaseStartAngle(newStartAngle: endAngle)
            
            shapes.append(shape)
        }
        
        return shapes
    }
    
    init(radius: CGFloat, startPoint: CGPoint){
        self.radius = radius
        self.startPoint = startPoint
    }
}

