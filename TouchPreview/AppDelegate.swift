//
//  Created by Brian Coyner on 11/20/15.
//  Copyright © 2015 Brian Coyner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Feel free to manage the window how ever you need to in your own app.
    // For this demo, the `PreviewWindow` is always "on".
    lazy var window: UIWindow? = {
        return PreviewWindow()
    }()
}
