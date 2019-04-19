## Touch Preview Demo

Visualize touches on iOS devices and iOS Simulators. Perfect for creating app tutorials or when giving live app demonstrations. 

* Supports multiple touches.
* Supports 3D Touch.
* Easy to integrate with your own app.

### How do I use it in my own app?

* Clone this repository.
* Grab the `PreviewWindow`.
* Update your app's key window to be an instance of a `PreviewWindow`.
* That's it, you're done. 

### How can I toggle the touches?

That's up to you. Here are some ideas:

* Use a custom build-time flag to compile "in" the `PreviewWindow`.
* Use an app-launch environment variable.
* Use some other mechanism that makes sense for your project.

### How does it all work?

Go ahead and check the [source code](https://github.com/briancoyner/TouchPreview/blob/master/TouchPreview/PreviewWindow.swift) to see how it works (there's not much to it).

### Where's the CocoaPod? 

Uh... It's a single file. Just copy, paste and modify to meet your needs.
