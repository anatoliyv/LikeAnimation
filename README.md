# Like Animation for iOS

![LikeAnimation](https://cloud.githubusercontent.com/tmp.png)

[![CI Status](http://img.shields.io/travis/anatoliyv/LikeAnimation.svg?style=flat)](https://travis-ci.org/anatoliyv/LikeAnimation)
[![Version](https://img.shields.io/cocoapods/v/LikeAnimation.svg?style=flat)](http://cocoapods.org/pods/LikeAnimation)
[![License](https://img.shields.io/cocoapods/l/LikeAnimation.svg?style=flat)](http://cocoapods.org/pods/LikeAnimation)
[![Platform](https://img.shields.io/cocoapods/p/LikeAnimation.svg?style=flat)](http://cocoapods.org/pods/LikeAnimation)

Like animation (heart beating):

[*] Easy to add to your project
[*] Customizable colors
[*] Customizable particles
[*] Has delegation to handle `willBegin` and `didEnd` events

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first to select best 
properties suitable for your project.

## Requirements

Swift 3 and iOS 9.0

## Installation

LikeAnimation is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LikeAnimation"
```

## Usage

Create an animation.

```
let likeAnimation = LikeAnimation(frame: CGRect(origin: yourPlaceholderView, size: CGSize(width: 100, height: 100)))
```

Customize duration to 1.5 seconds.

```
likeAnimation.duration = 1.5
```

Customize particles counters.

```
likeAnimation.circlesCounter = 1            // One cirlce
likeAnimation.particlesCounter.main = 6     // 6 big particles
likeAnimation.particlesCounter.small = 7    // 7 particles between big particles
```

Customize colors if required. Default fill color is white for all elements.

```
likeAnimation.heartColors.initial = .white
likeAnimation.heartColors.animated = .orange
likeAnimation.particlesColor = .orange
```

Set delegate methods:

```
likeAnimation.delegate = self
```

in your delegate implementation

```
func likeAnimationWillBegin(view: LikeAnimation) {
    print("Like animation will start")
}

func likeAnimationDidEnd(view: LikeAnimation) {
    print("Like animation ended")
}
```

Run

```
likeAnimation.run()
```

## Author

- anatoliy.voropay@gmail.com
- [@anatoliyv](https://twitter.com/anatoliyv)
- [LinkedIn](https://www.linkedin.com/in/anatoliyvoropay)

## License

LikeAnimation is available under the MIT license. See the LICENSE file for more info.
