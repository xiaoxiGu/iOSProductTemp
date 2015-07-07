//
//  BlinkView.swift
//  QooccHealth
//
//  Created by 肖小丰 on 15/5/18.
//  Copyright (c) 2015年 Liuyu. All rights reserved.
//

import Foundation

// MARK: - BlinkLayer animations
private let BlinkLayerPositionAnimationKey = "positionAnimation"
private let BlinkLayerTransformAnimationKey = "transformAnimation"
private let BlinkLayerOpacityAnimationKey = "opacityAnimation"

private let BlinkLayerEmitterShapeKey = "circle"
private let BlinkLayerEmitterModeKey = "surface"
private let BlinkLayerRenderModeKey = "unordered"
private let BlinkLayerMagnificationFilter = "linear"
private let BlinkLayerMinificationFilter = "trilinear"

/**
*  闪烁ViewLayer
*/
class BlinkViewLayer: CAEmitterLayer {
     init(blinkImageSring:String) {
        super.init()
        
        // this could be a lot better in terms of performance, but not today
        var blinkImage: UIImage?
        blinkImage = UIImage(named: blinkImageSring)
        
        let emitterCells: [CAEmitterCell] = [CAEmitterCell(), CAEmitterCell()]
        for cell in emitterCells {
            cell.birthRate = 8
            cell.lifetime = 1.25
            cell.lifetimeRange = 0
            cell.emissionRange = CGFloat(M_PI_4)
//            cell.velocity = 2
//            cell.velocityRange = 18
            cell.scale = 0.68
            cell.scaleRange = 0.7
            cell.scaleSpeed = 0.6
//            cell.spin = 0.6
//            cell.spinRange = CGFloat(M_PI)
            cell.color = UIColor(white: 1.0, alpha: 0.3).CGColor
            cell.alphaSpeed = -0.8
            cell.contents = blinkImage?.CGImage
            cell.magnificationFilter = BlinkLayerMagnificationFilter
            cell.minificationFilter = BlinkLayerMinificationFilter
            cell.enabled = true
        }
        self.emitterCells = emitterCells
        
        self.emitterPosition = CGPointMake((bounds.size.width * 0.5), (bounds.size.height * 0.5))
        self.emitterSize = bounds.size
        
        self.emitterShape = BlinkLayerEmitterShapeKey
        self.emitterMode = BlinkLayerEmitterModeKey
        self.renderMode = BlinkLayerRenderModeKey
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // MARK: - PublickMeath
    func addPositionAnimation() {
        CATransaction.begin()
        var keyFrameAnim = CAKeyframeAnimation(keyPath: "position")
        keyFrameAnim.duration = 0.3
        keyFrameAnim.additive = true
        keyFrameAnim.repeatCount = MAXFLOAT
        keyFrameAnim.removedOnCompletion = false
        keyFrameAnim.beginTime = CFTimeInterval(arc4random_uniform(1000) + 1) * 0.2 * 0.25 // random start time, non-zero
        let points: [NSValue] = [NSValue(CGPoint: self.twinkleRandom(0.25)),NSValue(CGPoint: self.twinkleRandom(0.25)),NSValue(CGPoint: self.twinkleRandom(0.25)),NSValue(CGPoint: self.twinkleRandom(0.25)),NSValue(CGPoint: self.twinkleRandom(0.25))]
        keyFrameAnim.values = points
        self.addAnimation(keyFrameAnim, forKey: BlinkLayerPositionAnimationKey)
        CATransaction.commit()
    }
    
    func addRotationAnimation() {
        CATransaction.begin()
        var keyFrameAnim = CAKeyframeAnimation(keyPath: "transform")
        keyFrameAnim.duration = 0.3
        keyFrameAnim.valueFunction = CAValueFunction(name: kCAValueFunctionRotateZ)
        keyFrameAnim.additive = true
        keyFrameAnim.repeatCount = MAXFLOAT
        keyFrameAnim.removedOnCompletion = false
        keyFrameAnim.beginTime = CFTimeInterval(arc4random_uniform(1000) + 1) * 0.2 * 0.25 // random start time, non-zero
        let radians: Float = 0.104 // ~6 degrees
        keyFrameAnim.values = [-radians, radians, -radians]
        self.addAnimation(keyFrameAnim, forKey: BlinkLayerTransformAnimationKey)
        CATransaction.commit()
    }
    
    func addFadeInOutAnimation(beginTime: CFTimeInterval) {
        CATransaction.begin()
        var fadeAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1
        fadeAnimation.repeatCount = HUGE
        fadeAnimation.autoreverses = true // fade in then out
        fadeAnimation.duration = 0.4
        fadeAnimation.fillMode = kCAFillModeForwards
        fadeAnimation.beginTime = beginTime
//        CATransaction.setCompletionBlock({
//            self.removeFromSuperlayer()
//        })
        self.addAnimation(fadeAnimation, forKey: BlinkLayerOpacityAnimationKey)
        CATransaction.commit()
    }
    // MARK: - PrivateMeath
    func twinkleRandom(range: Float)->CGPoint {
        let x = Int(-range + (Float(arc4random_uniform(1000)) / 1000.0) * 2.0 * range)
        let y = Int(-range + (Float(arc4random_uniform(1000)) / 1000.0) * 2.0 * range)
        return CGPoint(x: x, y: y)
    }
}
/**
*  散落动画View
*/
class FallViewLayer: CAEmitterLayer {
    
    private(set) var imageNameArray = [String]() //散落图片
    
    init(fallImageSring:String!) {
        super.init()
        self.imageNameArray.append(fallImageSring)
        self.initializeValue()
    }

    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    
    //MARK:- Delegate or DataSource
    
    //MARK:- NSNotification Method
    
    //MARK:- Action Method
    
    //MARK:- Private Method
    
    private func initializeValue(){
        // Configure the particle emitter to the top edge of the screen
        let parentLayer = self
        parentLayer.emitterPosition = CGPointMake(320 / 2.0, -30)
        parentLayer.emitterSize		= CGSizeMake(320 * 2.0, 0)
        
        // Spawn points for the flakes are within on the outline of the line
        parentLayer.emitterMode		= kCAEmitterLayerOutline
        parentLayer.emitterShape	= kCAEmitterLayerLine
        
        parentLayer.shadowOpacity = 1.0
        parentLayer.shadowRadius  = 0.0
        parentLayer.shadowOffset  = CGSizeMake(0.0, 1.0)
        parentLayer.shadowColor   = UIColor.whiteColor().CGColor
        parentLayer.seed = (arc4random()%100)+1
        
        
        let containerLayer = self.createSubLayerContainer()
        
        let subLayerArray = NSMutableArray()
        let contentArray = self.getContentsByArray(self.imageNameArray)
        for image in contentArray {
        subLayerArray.addObject(self.createSubLayer(image as! UIImage))
        }
        
        if containerLayer != nil {
            containerLayer!.emitterCells = subLayerArray as [AnyObject]
            parentLayer.emitterCells = [containerLayer!]
        }else{
            parentLayer.emitterCells = subLayerArray as [AnyObject]
        }

    }
    
    private func createSubLayerContainer() -> CAEmitterCell?{
        let containerLayer = CAEmitterCell()
        containerLayer.birthRate = 10.0
        containerLayer.velocity	= 0
        containerLayer.lifetime	= 0.35
        return containerLayer
    }
    
    private func getContentsByArray(imageNameArray:NSArray) -> NSArray{
        let retArray = NSMutableArray()
        for imageName in imageNameArray{
            let image = UIImage(named: imageName as! String)
            if image != nil {
                retArray.addObject(image!)
            }
        }
        return retArray
    }
    private func createSubLayer(image:UIImage) -> CAEmitterCell{
        let cellLayer = CAEmitterCell()
        
        cellLayer.birthRate		= 6.0
        cellLayer.lifetime		= 20
        
        cellLayer.velocity		= -200;			// falling down slowly
        cellLayer.velocityRange = 100
        cellLayer.yAcceleration = 50
        cellLayer.emissionLatitude = 0
        cellLayer.emissionLongitude = -CGFloat(M_PI_2)
        cellLayer.emissionRange = CGFloat(M_PI_4)/4		// some variation in angle
        //    cellLayer.spinRange		= 0.25 * M_PI;		// slow spin
        cellLayer.scale = 0.35
        cellLayer.scaleRange = 0.8
        cellLayer.contents = image.CGImage
        cellLayer.color	= UIColor.whiteColor().CGColor
        
        cellLayer.spin = 1
        cellLayer.spinRange = 0.68
        
        
        return cellLayer;

    }
}


/**
*  View的扩展 闪烁动画View
*/
extension UIView {
    /**
    添加闪烁动画
    :param: pointArray 闪烁动画View的位置和个数
    :param: blinkImage 闪烁图片
    */
    func addBlinkImageView(pointArray:[CGRect] ,blinkImage:String){
        for i in 0..<pointArray.count {
            let twinkleLayer = BlinkViewLayer(blinkImageSring: blinkImage)
//            twinkleLayer.bounds = pointArray[i]
            twinkleLayer.position = CGPointMake(pointArray[i].origin.x + 30, pointArray[i].origin.y)
            twinkleLayer.opacity = 1
            self.layer.addSublayer(twinkleLayer)
            
            twinkleLayer.addPositionAnimation()
            twinkleLayer.addRotationAnimation()
            twinkleLayer.addFadeInOutAnimation( CACurrentMediaTime() + CFTimeInterval(0.15 * Float(i)) )
        }
    }
    /**
    添加散落动画
    :param: blinkImage 散落图片
    */
    func addFallImageView(fallImage:String){
        self.layer.addSublayer(FallViewLayer(fallImageSring: fallImage))
    }
}