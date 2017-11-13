ImageOverlay
---
Provides `overlayContentView`(ish) for tvOS10 or earlier.

![](https://github.com/toshi0383/assets/blob/master/ImageOverlay/imageoverlay-tvos11.gif?raw=true)

![platforms](https://img.shields.io/badge/platforms-tvOS-blue.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-brightgreen.svg)](https://cocoapods.org)
[![pod](https://img.shields.io/cocoapods/v/ImageOverlay.svg?style=flat)](https://cocoapods.org/pods/ImageOverlay)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

In tvOS 11, UIImageView has `overlayContentView` to display custom UI over an UIImageView, while still enabling nice motion effect.

[<img src='https://github.com/toshi0383/assets/blob/master/ImageOverlay/wwdc2017-209.png?raw=true' width='400' />](https://developer.apple.com/videos/play/wwdc2017/209/)

This library provides the similar functionality for tvOS 9 or 10.

# Features
- [x] Render CALayer
- [x] Render UIView
- [x] Render UIView with autolayout
- [x] Render multiple overlays
- [x] Render user defined overlays.
- [x] [tvOS 11] Choose either `overlayContentView` or rendering as image
- [x] [Built-in] `FillAspectRatioOverlay`
- [x] [Built-in] `AlphaGradientOverlay`

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

NOTE: Everything is rendered as image on tvOS 10 or earlier.

# How to use
## `OverlayProtocol`: CALayer based overlay
Conform to either `OverlayProtocol` to define your own overlay.  
Make sure to set `bounds` on toplevel layer, and set `frame` to sublayers.

See [TextOverlay.swift](ImageOverlay/TextOverlay.swift) for example.

## `OverlayViewProtocol`: UIView based overlay
Conform to `OverlayViewProtocol` for view based overlay.

See [ExampleOverlays.swift](Example/ExampleOverlays.swift) for example.

## `needsRendering`: always render as image
Return `true` in `needsRendering` to always render layers or views as image.

# LICENSE
MIT

