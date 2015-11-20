//
//  Created by Brian Coyner on 11/20/15.
//  Copyright © 2015 Brian Coyner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var previewWindow: PreviewWindow?
    
    var window: UIWindow? {
        get {
            if let previewWindow = self.previewWindow {
                return previewWindow
            } else {
                self.previewWindow = PreviewWindow()
                return previewWindow
            }
        }
        set {           
        }
    }
}

