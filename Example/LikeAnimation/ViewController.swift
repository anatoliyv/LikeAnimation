//
//  ViewController.swift
//  LikeAnimation
//
//  Created by Anatoliy Voropay on 03/15/2017.
//  Copyright (c) 2017 Anatoliy Voropay. All rights reserved.
//

import UIKit
import LikeAnimation

class ViewController: UIViewController {
    
    @IBOutlet var durationSlider: UISlider!
    @IBOutlet var mainParticlesSlider: UISlider!
    @IBOutlet var smallParticlesSlider: UISlider!
    @IBOutlet var circlesSlider: UISlider!
    
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var mainParticlesLabel: UILabel!
    @IBOutlet var smallParticlesLabel: UILabel!
    @IBOutlet var circlesLabel: UILabel!
    
    @IBOutlet var placeholderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        durationSlider.minimumValue = Float(LikeAnimation.Constants.DurationMin)
        durationSlider.maximumValue = Float(LikeAnimation.Constants.DurationMax)
        
        mainParticlesSlider.minimumValue = Float(LikeAnimation.Constants.MainParticlesMin)
        mainParticlesSlider.maximumValue = Float(LikeAnimation.Constants.MainParticlesMax)
        
        smallParticlesSlider.minimumValue = Float(LikeAnimation.Constants.SmallParticlesMin)
        smallParticlesSlider.maximumValue = Float(LikeAnimation.Constants.SmallParticlesMax)
        
        circlesSlider.minimumValue = Float(LikeAnimation.Constants.CirclesMin)
        circlesSlider.maximumValue = Float(LikeAnimation.Constants.CirclesMax)
        
        setDefaultValues()
        sliderValueChanged(slider: durationSlider)
    }
    
    private func setDefaultValues() {
        let likeAnimation = LikeAnimation()
        durationSlider.value = Float(likeAnimation.duration)
        mainParticlesSlider.value = Float(likeAnimation.particlesCounter.main)
        smallParticlesSlider.value = Float(likeAnimation.particlesCounter.small)
        circlesSlider.value = Float(likeAnimation.circlesCounter)
    }
    
    @IBAction func sliderValueChanged(slider: UISlider) {
        durationLabel.text = String(format: "%0.2f", durationSlider.value)
        mainParticlesLabel.text = String(Int(mainParticlesSlider.value))
        smallParticlesLabel.text = String(Int(smallParticlesSlider.value))
        circlesLabel.text = String(Int(circlesSlider.value))
    }
    
    @IBAction func runPressed(button: UIButton) {
        let likeAnimation = LikeAnimation(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100)))
        likeAnimation.center = placeholderView.center
        likeAnimation.duration = TimeInterval(durationSlider.value)
        likeAnimation.circlesCounter = Int(circlesSlider.value)
        likeAnimation.particlesCounter.main = Int(mainParticlesSlider.value)
        likeAnimation.particlesCounter.small = Int(smallParticlesSlider.value)
        likeAnimation.delegate = self
        
        // Set custom colors here
        // likeAnimation.heartColors.initial = .white
        // likeAnimation.heartColors.animated = .orange
        // likeAnimation.particlesColor = .orange
        
        placeholderView.addSubview(likeAnimation)
        likeAnimation.run()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: LikeAnimationDelegate {
    
    func likeAnimationWillBegin(view: LikeAnimation) {
        print("Like animation will start")
    }
    
    func likeAnimationDidEnd(view: LikeAnimation) {
        print("Like animation ended")
    }
}
