//
//  Created by Brian Coyner on 6/29/15.
//  Copyright (c) 2015 Brian Coyner. All rights reserved.
//

import UIKit

class PreviewWindow: UIWindow {

    // MARK: Private Properties
    
    private var forceTouchAvailable = false
    private var touchesToViews: [UITouch:UIView] = [:]

    // MARK: Event Handling
    
    override func sendEvent(event: UIEvent) {
        
        if event.type == .Touches {
            
            if let allTouches = event.touchesForWindow(self) {
                
                for touch in allTouches {
                    switch touch.phase {
                    case .Began:
                        self.handleTouchBegan(touch)
                    case .Moved:
                        self.handleTouchMoved(touch)
                    case .Cancelled:
                        self.handleTouchCancelled(touch)
                    case .Ended:
                        self.handleTouchEnded(touch)
                    case .Stationary:
                        break
                    }
                }
            }
        }

        super.sendEvent(event)
    }

    // MARK: Capture 3D Touch Availability
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        self.forceTouchAvailable = self.traitCollection.forceTouchCapability == .Available
    }
    
    // MARK: Preview Window Touch Handling (Private)
    
    private func handleTouchBegan(touch: UITouch) {

        // create a view for the touch
        let startingPoint = touch.locationInView(self)
        let touchView = self.touchViewWithInitialStartingPoint(startingPoint)
        
        // track the touch + view so we can get it later
        self.touchesToViews[touch] = touchView
        self.addSubview(touchView)

        // fade and scale it in for a "nice" effect
        touchView.alpha = 0.0
        UIView.animateWithDuration(0.1, animations: {
            touchView.alpha = 1.0
            touchView.transform = CGAffineTransformIdentity
        })
    }

    private func handleTouchMoved(touch: UITouch) {
        if let touchView = self.touchesToViews[touch] {
            
            // 3D touch handling, if available
            if self.forceTouchAvailable {
                let scale = ((touch.force / touch.maximumPossibleForce) * 4.0) + 1
                touchView.transform = CGAffineTransformMakeScale(scale, scale)
            }
            
            // reposition the view under the touch
            touchView.center = touch.locationInView(self)
        }
    }

    private func handleTouchCancelled(touch: UITouch) {
        self.handleTouchEnded(touch)
    }

    private func handleTouchEnded(touch: UITouch) {

        if let touchView = self.touchesToViews[touch] {

            // fade and scale it out for a "nice" effect
            UIView.animateWithDuration(0.1, animations: {
                touchView.alpha = 0.0
                touchView.transform = CGAffineTransformMakeScale(1.20, 1.20)
            }, completion: { (Bool) in
                touchView.removeFromSuperview()
                self.touchesToViews[touch] = nil
            })
        }
    }
    
    // MARK: View Creation
    
    private func touchViewWithInitialStartingPoint(startingPoint: CGPoint) -> UIView {
        let touchView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))

        touchView.center = startingPoint
        touchView.transform = CGAffineTransformMakeScale(1.20, 1.20)
        
        // set up layout
        let layer = touchView.layer
        layer.contentsScale = UIScreen.mainScreen().scale
        layer.cornerRadius = touchView.bounds.width / 2.0
        layer.borderWidth = 1.0

        // configure color
        var backgroundColor = UIColor.lightGrayColor()
        backgroundColor = backgroundColor.colorWithAlphaComponent(0.7)
        touchView.backgroundColor = backgroundColor
        layer.borderColor = UIColor.darkGrayColor().CGColor
        
        return touchView
    }
}