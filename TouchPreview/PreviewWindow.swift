//
//  Created by Brian Coyner on 6/29/15.
//  Copyright (c) 2015 Brian Coyner. All rights reserved.
//

import UIKit

class PreviewWindow: UIWindow {

    fileprivate var forceTouchAvailable = false
    fileprivate var touchesToViews: [UITouch:UIView] = [:]

    // MARK: Event Handling
    
    override func sendEvent(_ event: UIEvent) {
        
        if event.type == .touches {
            if let allTouches = event.touches(for: self) {
                for touch in allTouches {
                    switch touch.phase {
                    case .began:
                        handleTouchBegan(touch)
                    case .moved:
                        handleTouchMoved(touch)
                    case .cancelled:
                        handleTouchCancelled(touch)
                    case .ended:
                        handleTouchEnded(touch)
                    case .stationary:
                        break
                    @unknown default:
                        break
                    }
                }
            }
        }

        super.sendEvent(event)
    }

    // MARK: Capture 3D Touch Availability
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        forceTouchAvailable = traitCollection.forceTouchCapability == .available
    }
    
    // MARK: Preview Window Touch Handling (Private)
    
    fileprivate func handleTouchBegan(_ touch: UITouch) {

        // create a view for the touch
        let startingPoint = touch.location(in: self)
        let touchView = self.touchView(withInitialStartingPoint: startingPoint)
        
        // track the touch + view so we can get it later
        touchesToViews[touch] = touchView
        addSubview(touchView)

        // fade and scale it in for a "nice" effect
        touchView.alpha = 0.0
        
        // scaling it up first makes it appear as if it's dropping on to the screen
        // when we animate back to its identity.
        touchView.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
        
        UIView.animate(withDuration: 0.1, animations: {
            touchView.alpha = 1.0
            touchView.transform = CGAffineTransform.identity
        })
    }

    fileprivate func handleTouchMoved(_ touch: UITouch) {
        if let touchView = touchesToViews[touch] {
            
            // 3D touch handling, if available
            if forceTouchAvailable {
                let scale = ((touch.force / touch.maximumPossibleForce) * 4.0) + 1
                touchView.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
            // reposition the view under the touch
            touchView.center = touch.location(in: self)
        }
    }

    fileprivate func handleTouchCancelled(_ touch: UITouch) {
        handleTouchEnded(touch)
    }

    fileprivate func handleTouchEnded(_ touch: UITouch) {

        if let touchView = touchesToViews[touch] {

            // fade and scale it out for a "nice" effect
            UIView.animate(withDuration: 0.1, animations: {
                touchView.alpha = 0.0
                touchView.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
            }, completion: { (_) in
                touchView.removeFromSuperview()
                self.touchesToViews[touch] = nil
            })
        }
    }
    
    // MARK: View Creation
    
    fileprivate func touchView(withInitialStartingPoint startingPoint: CGPoint) -> UIView {
        let touchView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))

        touchView.center = startingPoint
        
        // set up layout
        let layer = touchView.layer
        layer.contentsScale = UIScreen.main.scale
        layer.cornerRadius = touchView.bounds.width / 2.0
        layer.borderWidth = 1.0

        // configure color
        var backgroundColor = UIColor.lightGray
        backgroundColor = backgroundColor.withAlphaComponent(0.7)
        touchView.backgroundColor = backgroundColor
        layer.borderColor = UIColor.darkGray.cgColor
        
        return touchView
    }
}
