//
//  LikeAnimation.swift
//  Pods
//
//  Created by Anatoliy Voropay on 3/15/17.
//
//

import UIKit

/// Handle view events
public protocol LikeAnimationDelegate : class {
    
    /// Animation will begin event
    func likeAnimationWillBegin(view: LikeAnimation)
    
    /// Animation did end event
    func likeAnimationDidEnd(view: LikeAnimation)
}

/// LikeAnimation
public class LikeAnimation: UIView {
    
    // MARK: Constatns 
    
    public struct Constants {
        
        /// Duration min and max time intervals
        public static let DurationMin = TimeInterval(0.5)
        public static let DurationMax = TimeInterval(3)
        
        /// Circles min and max count
        public static let CirclesMin = 0
        public static let CirclesMax = 3
        
        /// Main particles min and max count
        public static let MainParticlesMin = 3
        public static let MainParticlesMax = 13
        
        /// Small particles min and max count
        public static let SmallParticlesMin = 0
        public static let SmallParticlesMax = 13
    }
    
    // MARK: Customization
    
    /// Animation duration time
    public var duration: TimeInterval = TimeInterval(1.5)
    
    /// Color of a heart
    public var heartColors: (initial: UIColor, animated: UIColor) = (.white, .white)
    
    /// Number of circles in animation
    public var circlesCounter: Int = 1
    
    /// Color of the particles
    public var particlesColor: UIColor = .white
    
    public var delegate: LikeAnimationDelegate?

    /// Particles counter.
    ///
    /// * main:
    /// Big particles count. They are placed on equal angel between each other.
    /// I.e. if number of main particles is 7 there will be 360 / 8 = 45 degrees betwen every
    /// particle.
    ///
    /// * small:
    /// Number of smaller particles between two main particles.
    public var particlesCounter: (main: Int, small: Int) = (6, 7)
    
    /// Show animation
    public func run() {
        guard checkProperties() else { return }
        
        layer.addSublayer(circleLayer)
        layer.addSublayer(heartLayer)
        layer.addSublayer(particlesLayer)
        
        delegate?.likeAnimationWillBegin(view: self)
        
        runCircleAnimations()
        runHeartAnimations()
        runParticleAnimations()
        
        perform(#selector(animationComplete), with: nil, afterDelay: duration * 2)
    }
    
    @objc private func animationComplete() {
        delegate?.likeAnimationDidEnd(view: self)
    }
    
    // MARK: Private
    
    private lazy var circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = self.particlesColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.frame = self.bounds
        layer.fillMode = kCAFillModeBoth
        layer.lineWidth = 0.5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        return layer
    }()
    
    private lazy var heartLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = self.heartColors.0.cgColor
        layer.fillMode = kCAFillModeForwards
        layer.frame = self.bounds
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 7.0
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        return layer
    }()
    
    private lazy var particlesLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = self.particlesColor.cgColor
        layer.fillMode = kCAFillModeForwards
        layer.frame = self.bounds
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        return layer
    }()
    
    // MARK: Circle
    
    fileprivate func runCircleAnimations() {
        let sequence = AnimationSequence()
        
        sequence.addDelay(
            duration: duration / 5 + duration / 20,
            beforeAction: {
                self.circleLayer.opacity = 0
        }, afterAction: {
            self.circleLayer.opacity = 1
        })
        
        sequence.add(
            animation: AnimationGroup(
                duration: duration / 2,
                animations:
                Animation(p: "path", f: circlePath(radius: 0).cgPath,
                          t: circlePath(radius: frame.height / 2).cgPath,
                          d: duration / 3, b: nil, a: nil),
                Animation(p: "lineWidth", f: bounds.height / 3, t: 0.5,
                          d: duration / 3, b: nil, a: nil)
        ))
        
        sequence.add(
            animation: Animation(p: "opacity", f: 1, t: 0, d: duration / 5, b: nil, a: nil))
        
        circleLayer.path = circlePath(radius: frame.height / 2).cgPath
        sequence.runAnimationsOnLayer(circleLayer)
    }
    
    private func circlePath(radius: CGFloat) -> UIBezierPath {
        guard circlesCounter > 0 else { return UIBezierPath() }

        let path = UIBezierPath()
        for i in 0..<circlesCounter {
            let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
            path.addArc(
                withCenter: center,
                radius: radius * (1 - CGFloat(i) * 0.1),
                startAngle: 0,
                endAngle: CGFloat(2 * M_PI),
                clockwise: true)
            path.close()
        }
        
        return path
    }
    
    // MARK: Heart
    
    private func runHeartAnimations() {
        let sequence = AnimationSequence()
        
        sequence.add(animation:
            AnimationGroup(
                duration: duration / 3,
                animations:
                Animation(p: "transform.scale", f: 0.8, t: 1, d: duration / 5 / 2, b: nil, a: nil),
                Animation(p: "opacity", f: 0, t: 1, d: duration / 20, b: nil, a: nil)
            )
        )
        
        sequence.add(animation:
            Animation(p: "transform.scale", f: 1, t: 0,
                      d: duration / 20, b: nil, a: {
                        self.heartLayer.path = nil
                        self.heartLayer.fillColor = self.heartColors.1.cgColor
            })
        )
        
        sequence.add(animation:
            Animation(p: "transform.scale", f: 0, t: 1.1,
                      d: duration / 4, b: { self.heartLayer.path = self.heartPath().cgPath }, a: nil)
        )
        
        sequence.add(animation:
            Animation(p: "transform.scale", f: 1.1, t: 0.9,
                      d: duration / 8, b: nil, a: nil)
        )
        
        sequence.add(animation:
            Animation(p: "transform.scale", f: 0.9, t: 1.05,
                      d: duration / 7, b: nil, a: nil)
        )
        
        sequence.add(animation:
            Animation(p: "transform.scale", f: 1.05, t: 1,
                      d: duration / 6, b: nil, a: nil)
        )
        
        sequence.addDelay(
            duration: duration / 5)
        
        sequence.add(animation:
            Animation(p: "opacity", f: 1, t: 0,
                      d: duration / 5, b: nil, a: { self.heartLayer.path = nil })
        )
        
        heartLayer.path = heartPath().cgPath
        sequence.runAnimationsOnLayer(heartLayer)
    }
    
    private func heartPath() -> UIBezierPath {
        let path = UIBezierPath()
        let factor = CGFloat(6)
        let topSpace = self.bounds.height / 20
        let bounds = CGRect(x: self.bounds.width / factor,
                            y: topSpace + self.bounds.height / factor,
                            width: self.bounds.width - 2 * ( self.bounds.width / factor ),
                            height: self.bounds.height - 2 * (self.bounds.height / factor ))
        // Bottom center
        
        path.move(to: CGPoint(x: bounds.origin.x + bounds.size.width / 2,
                              y: bounds.origin.y + bounds.size.height))
        
        let to11 = CGPoint(x: bounds.origin.x,
                           y: bounds.origin.y + (bounds.size.height / 4))
        let cp11 = CGPoint(x: bounds.origin.x + (bounds.size.width / 2),
                           y: bounds.origin.y + bounds.size.height)
        let cp12 = CGPoint(x: bounds.origin.x,
                           y: bounds.origin.y + (bounds.size.height / 2))
        path.addCurve(to: to11, controlPoint1: cp11, controlPoint2: cp12)
        
        let c21 = CGPoint(x: bounds.origin.x + (bounds.size.width / 4),
                          y: bounds.origin.y + (bounds.size.height / 4))
        path.addArc(withCenter: c21,
                    radius: bounds.size.width / 4,
                    startAngle: CGFloat(M_PI),
                    endAngle: 0,
                    clockwise: true)
        
        let c32 = CGPoint(x: bounds.origin.x + bounds.size.width * 3 / 4,
                          y: bounds.origin.y + bounds.size.height / 4)
        path.addArc(withCenter: c32,
                    radius: bounds.size.width / 4,
                    startAngle: CGFloat(M_PI),
                    endAngle: 0,
                    clockwise: true)
        
        let to41 = CGPoint(x: bounds.origin.x + bounds.size.width / 2,
                           y: bounds.origin.y + bounds.size.height)
        let cp41 = CGPoint(x: bounds.origin.x + bounds.size.width,
                           y: bounds.origin.y + (bounds.size.height / 2))
        let cp42 = CGPoint(x: bounds.origin.x + (bounds.size.width / 2),
                           y: bounds.origin.y + bounds.size.height)
        path.addCurve(to: to41, controlPoint1: cp41, controlPoint2: cp42)
        
        path.close()
        return path
    }
    
    // MARK: Particles
    
    private func runParticleAnimations() {
        let sequence = AnimationSequence()
        sequence.addDelay(duration: duration / 5 + duration / 20 + duration / 3 * 0.85)
        sequence.add(
            animation: AnimationGroup(
                duration: duration / 5,
                animations:
                Animation(
                    p: "opacity", f: 0, t: 1, d: duration / 5,
                    b: {
                        self.particlesLayer.path = self.particlesPath(scale: 0, reverse: false).cgPath
                }, a: {
                    
                }),
                Animation(
                    p: "path", f: particlesPath(scale: 0, reverse: false).cgPath,
                    t: particlesPath(scale: 0.5, reverse: false).cgPath,
                    d: duration / 5,
                    b: nil,
                    a: nil)
        ))
        sequence.add(
            animation: AnimationGroup(
                duration: duration / 3,
                animations:
                Animation(
                    p: "path", f: particlesPath(scale: 0.5, reverse: false).cgPath,
                    t: particlesPath(scale: 1, reverse: true).cgPath,
                    d: duration / 3,
                    b: nil, a: {
                        self.particlesLayer.opacity = 0
                })
        ))
        
        sequence.runAnimationsOnLayer(particlesLayer)
    }
    
    private func particlesPath(scale: CGFloat, reverse: Bool) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let mainAngel = M_PI * 2 / Double(particlesCounter.main)
        let mainSubangel = mainAngel / Double((particlesCounter.small + 1))
        
        func quadratic(_ i: CGFloat) -> CGFloat {
            if i >= 0.1 && i < 0.2 { return 0.1 }
            else if i >= 0.2 && i < 0.3 { return 0.3 }
            else if i >= 0.3 && i < 0.4 { return 0.6 }
            else if i >= 0.4 && i < 0.5 { return 0.85 }
            else if i >= 0.5 && i < 0.6 { return 0.1 }
            else if i >= 0.6 && i < 0.7 { return 0.85 }
            else if i >= 0.7 && i < 0.8 { return 0.6 }
            else if i >= 0.8 && i < 0.9 { return 0.3 }
            else { return 0 }
        }
        
        for i in 0..<Int(particlesCounter.main) {
            let angel = Double(i) * mainAngel
            let radius = center.x * ( 0.8 + scale * 0.4 )
            let x = center.x + radius * CGFloat(cos(angel))
            let y = center.y + radius * CGFloat(sin(angel))
            let point = CGPoint(x: x, y: y)
            
            path.move(to: point)
            path.addArc(
                withCenter: point,
                radius: ( reverse ? 0 : 8 * scale ),
                startAngle: 0,
                endAngle: CGFloat(M_PI * 2),
                clockwise: true)
            
            for j in 0..<Int(particlesCounter.small) {
                let subangel = angel + Double(j + 1) * mainSubangel
                let x = center.x + radius * CGFloat(cos(subangel)) * (1 + 0.5 * quadratic(CGFloat(j) / CGFloat(particlesCounter.small + 1)))
                let y = center.y + radius * CGFloat(sin(subangel)) * (1 + 0.5 * quadratic(CGFloat(j) / CGFloat(particlesCounter.small + 1)))
                let point = CGPoint(x: x, y: y)
                
                path.move(to: point)
                path.addArc(
                    withCenter: point,
                    radius: ( reverse ? 0 : 1 + scale ),
                    startAngle: 0,
                    endAngle: CGFloat(M_PI * 2),
                    clockwise: true)
            }
        }
        
        path.close()
        
        return path
    }
}

/// Perform check if all parameters has suitable values
extension LikeAnimation {

    fileprivate func checkProperties() -> Bool {
        guard superview != nil else {
            assertionFailure("LikeAnimation should be added to any view")
            return false
        }
        
        guard circlesCounter >= Constants.CirclesMin && circlesCounter <= Constants.CirclesMax else {
            assertionFailure("Aninmation circles counter should be in range \(Constants.CirclesMin)...\(Constants.CirclesMax)")
            return false
        }
        
        guard particlesCounter.main >= Constants.MainParticlesMin && particlesCounter.main <= Constants.MainParticlesMax else {
            assertionFailure("Main particles counter should be in range \(Constants.MainParticlesMin)...\(Constants.MainParticlesMax)")
            return false
        }
        
        guard particlesCounter.small >= Constants.SmallParticlesMin && particlesCounter.main <= Constants.SmallParticlesMax else {
            assertionFailure("Small particles counter should be in range \(Constants.SmallParticlesMin)...\(Constants.SmallParticlesMax)")
            return false
        }
        
        guard duration >= Constants.DurationMin && duration <= Constants.DurationMax else {
            assertionFailure("Duration should be in range \(Constants.DurationMin)...\(Constants.DurationMax)")
            return false
        }
        
        return true
    }
}
