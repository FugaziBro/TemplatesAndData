//
//  File.swift
//  AniCheck
//
//  Created by Бакулин Семен Александрович on 17.10.2020.
//  Copyright © 2020 Бакулин Семен Александрович. All rights reserved.
//

import UIKit

class LayerProto: CAShapeLayer {
    
    private let mediator: LayerMediator!
    
    //MARK: - relation methods
    
    func animateRectangle(){
        mediator.animateRectangle()
    }
    
    //MARK: - inits
    override init(layer: Any) {
        self.mediator = LayerMediator()
        super.init(layer: layer)
    }
    
    init(mediator: LayerMediator) {
        self.mediator = mediator
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


final class LayerMediator {
    
    public var circleLayer: CircleLayer!
    public var rectangleLayer: RectangleLayer!
    
    func setupMediator(){
        self.circleLayer = CircleLayer(mediator: self)
        self.rectangleLayer = RectangleLayer(mediator: self)
    }
    
    //MARK: -Relation methods
    func animateRectangle(){
        rectangleLayer.opacity = 1
        self.rectangleLayer.animate()
    }
}

final class CircleLayer: LayerProto{
    
    func animate(){
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.removeFromSuperlayer()
            self.animateRectangle()
        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(opacity))
        animation.duration = 1
        animation.toValue = 0.4
        add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    //MARK: - inits
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override init(mediator: LayerMediator) {
        super.init(mediator: mediator)
        backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1).cgColor
        frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        cornerRadius = 100
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class RectangleLayer: LayerProto{
    
    func animate(){
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.removeFromSuperlayer()
        }
        
        let animation = CABasicAnimation(keyPath: #keyPath(bounds))
        animation.duration = 1
        animation.toValue = CGRect(x: 0, y: 0, width: 100, height: 100)
        add(animation, forKey: nil)
        
        CATransaction.commit()
    }
    
    //MARK: - inits
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    override init(mediator: LayerMediator) {
        super.init(mediator: mediator)
        backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor
        frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        cornerRadius = 15
        opacity = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
