//
//  AnimationsHelper.swift
//  Pods
//
//  Created by Anatoliy Voropay on 3/15/17.
//
//

import Foundation

/// Protocol for custom animation
protocol AnimationProtocol {
    func runAnimationOnLayer(_ layer: CAShapeLayer)
}

/// Custom animation with extended functionality
class Animation: AnimationProtocol {
    
    fileprivate var animation: CAAnimation?
    fileprivate var beforeAction: (() -> Void)?
    fileprivate var afterAction: (() -> Void)?
    
    init(animation: CAAnimation?,
         beforeAction before: (() -> Void)?,
         afterAction after: (() -> Void)?)
    {
        self.animation = animation
        self.beforeAction = before
        self.afterAction = after
    }
    
    init(animation: CAAnimation?) {
        self.animation = animation
    }
    
    convenience init(
        animationForKeyPath path: String,
        fromValue: Any,
        toValue: Any,
        duration: CFTimeInterval,
        beforeAction before: (() -> Void)?,
        afterAction after: (() -> Void)?)
    {
        let animation = CABasicAnimation(keyPath: path)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        self.init(animation: animation, beforeAction: before, afterAction: after)
    }
    
    convenience init(
        p: String,
        f: Any,
        t: Any,
        d: CFTimeInterval,
        b: (() -> Void)?,
        a: (() -> Void)?)
    {
        self.init(animationForKeyPath: p, fromValue: f, toValue:
            t, duration: d, beforeAction: b, afterAction: a)
    }
    
    convenience init(animation: CAAnimation?, beforeAction before: (() -> Void)?) {
        self.init(animation: animation, beforeAction: before, afterAction: nil)
    }
    
    convenience init(animation: CAAnimation?, afterAction after: (() -> Void)?) {
        self.init(animation: animation, beforeAction: nil, afterAction: after)
    }
    
    internal func runAnimationOnLayer(_ layer: CAShapeLayer) {
        beforeAction?()
        layer.add(animation!, forKey: nil)
    }
}

/// Group of animations appearing in the same time
class AnimationGroup: Animation {
    
    fileprivate var animations: [Animation] = []
    
    init(duration: CFTimeInterval, animations: Animation...) {
        let animationSequence = CAAnimationGroup()
        animationSequence.animations = []
        animationSequence.duration = duration
        animationSequence.isRemovedOnCompletion = false
        animationSequence.fillMode = kCAFillModeForwards
        
        for animation in animations {
            animationSequence.animations?.append(animation.animation!)
        }
        
        self.animations = animations
        super.init(animation: animationSequence)
        self.animation = animationSequence
    }
    
    override func runAnimationOnLayer(_ layer: CAShapeLayer) {
        for animation in animations {
            animation.beforeAction?()
        }
        
        super.runAnimationOnLayer(layer)
    }
}

/// Sequence of animation appearing one after another
class AnimationSequence: CAAnimation {
    
    fileprivate var animations: [Animation] = []
    fileprivate var layer: CAShapeLayer?
    fileprivate var index: Int = 0
    
    // MARK: Add animations
    
    func addDelay(duration: CFTimeInterval) {
        let animation = CABasicAnimation(keyPath: nil)
        animation.duration = duration
        animation.delegate = self
        animations.append(Animation(animation: animation))
    }
    
    func addDelay(
        duration: CFTimeInterval,
        beforeAction before: (() -> Void)?,
        afterAction after: (() -> Void)?)
    {
        let caAnimation = CABasicAnimation(keyPath: nil)
        caAnimation.duration = duration
        caAnimation.fillMode = kCAFillModeForwards
        caAnimation.delegate = self
        
        let animation = Animation(animation: caAnimation)
        animation.beforeAction = before
        animation.afterAction = after
        animations.append(animation)
    }
    
    func add(caAnimation: CAAnimation) {
        caAnimation.delegate = self
        caAnimation.fillMode = kCAFillModeForwards
        animations.append(Animation(animation: caAnimation))
    }
    
    func add(animation: Animation) {
        animation.animation?.delegate = self
        animations.append(animation)
    }
    
    // MARK: Perform animation
    
    func runAnimationsOnLayer(_ layer: CAShapeLayer) {
        guard let animation = animations.first else { return }
        
        self.index = 0
        self.layer = layer
        
        animation.runAnimationOnLayer(layer)
    }
}

/// `CAAnimationDelegate` protocol implementation
extension AnimationSequence: CAAnimationDelegate {
    
    public func animationDidStart(_ anim: CAAnimation) { }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }

        animations[index].afterAction?()
        index += 1
        
        guard index < animations.count else {
            return
        }
        
        let animation = animations[index]
        animation.beforeAction?()
        
        guard let caAnimation = animation.animation else { return }
        self.layer?.add(caAnimation, forKey: nil)
    }
}
