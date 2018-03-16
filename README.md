ImageOverlay
---
`overlayContentView` made easy and even cooler on tvOS.  
tvOS10 and earlier is surprisingly supported.

![](https://github.com/toshi0383/assets/blob/master/ImageOverlay/imageoverlay-tvos11.gif?raw=true)

![platforms](https://img.shields.io/badge/platforms-tvOS-blue.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://cocoapods.org)
[![pod](https://img.shields.io/cocoapods/v/ImageOverlay.svg?style=flat)](https://cocoapods.org/pods/ImageOverlay)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

In tvOS 11, `UIImageView` has `overlayContentView` to display custom UI over an `UIImageView`, while still enabling nice motion effect.

[<img src='https://github.com/toshi0383/assets/blob/master/ImageOverlay/wwdc2017-209.png?raw=true' width='400' />](https://developer.apple.com/videos/play/wwdc2017/209/)

With `ImageOverlay.framework`, you can combine your `UIView` overlays with `CALayer` and optionally render them as `UIImage` which will be rendered over the original thumbnail image.

Take a look at [ScreenShots below](#screenshots) and run [Example](Example) app using different tvOS version simulators.

# Features
- ✅ Render CALayer
- ✅ Render UIView
- ✅ Render UIView with autolayout
- ✅ Render multiple overlays
- ✅ Render user defined overlays.
- ✅ [tvOS 11] Choose either `overlayContentView` or render as image
- ✅ [Built-in] `FillAspectRatioOverlay`
- ✅ [Built-in] `AlphaGradientOverlay`
- ✅ Customizable image rendering queue (main thread by default)

# ScreenShots
Demonstrated overlays
- black bars to fill aspect ratio (rendered as image)
- black gradient alpha layer (rendered as image)
- "CATCHUP" label (on `overlayContentView`)
- "Free" label (on `overlayContentView`)

## tvOS 11
![](https://github.com/toshi0383/assets/blob/master/ImageOverlay/imageoverlay-tvos11.gif?raw=true)

## tvOS 9 and tvOS 10
![](https://github.com/toshi0383/assets/blob/master/ImageOverlay/imageoverlay-tvos10.gif?raw=true)

**NOTE**: Everything is rendered as image on tvOS 10 or earlier.

# How to use
## Setting and clearing image
- `imageView.io.addOverlays(with:overlays:)`
- `imageView.io.clearOverlays()`

**NOTE**: Don't nil-out imageView.image, otherwise overlayContentView doesn't get motion effects anymore. Seems like Apple's bug and I'm going to file a bug-report. Maybe you should too💪

## `OverlayProtocol`: CALayer based overlay
Conform to either `OverlayProtocol` to define your own overlay.  
Make sure to set `bounds` on toplevel layer, and set `frame` to sublayers.

See [TextOverlay.swift](ImageOverlay/TextOverlay.swift) for example.

## `OverlayViewProtocol`: UIView based overlay
Conform to `OverlayViewProtocol` for view based overlay.

See [ExampleOverlays.swift](Example/ExampleOverlays.swift) for example.

## `needsRendering`: always render as image (ignored on tvOS10)
Return `true` to always render layers or views as image on tvOS11.

# LICENSE
MIT
