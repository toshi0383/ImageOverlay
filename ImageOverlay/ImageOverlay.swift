//
//  ImageOverlay.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVFoundation
import UIKit

extension UIImageView: NameSpaceCompatible { }

// private struct AssociatedKeys {
//     static var overlayContentView = "ImageOverlay.overlayContentView"
// }

extension NameSpace where Base: UIImageView {

    /// Clear overlays from this UIImageView
    ///
    /// On tvOS 10 or earlier, this nil-outs `UIImageView.image` property.
    /// On tvOS 11, this removes added subviews from `UIImageView.overlayContentView`.
    /// Pass somewhat placeholder image to `addOverlay` API if you need to clear-out current image.
    ///
    /// - parameter doNotNilOutOnTVOS10orEarlier: only has effect on tvOS10 or earlier.
    ///     Useful when you set placeholder image via `addOverlay` to reset current image.
    ///     This way the behavior is consistent across OS versions.
    ///
    /// - NOTE: DO NOT set nil-out `UIImageView.image`!
    ///     `overlayContentView` won't work if you do.
    ///     I believe it's an Apple's bug.
    public func clearOverlays(doNotNilOutOnTVOS10orEarlier: Bool = false) {
        if #available(tvOS 11.0, *) {

            if let childOverlayView = base._childOverlayView {
                childOverlayView.removeFromSuperview()
                base._childOverlayView = nil
            }

            // IMPORTANT: Do not nil-out
            // base.image = nil

        } else {
            if !doNotNilOutOnTVOS10orEarlier {
                base.image = nil
            }
        }
    }

    /// Add overlays to this UIImageView
    ///
    /// - parameter image: non-nil UIImage pass placeholder image when you want to clear the image.
    /// - parameter overlays: array of OverlayProtocol objects
    /// - parameter imagePackagingQueue: [optional] specify any queue where you want the image rendering taken place.
    ///     Dare to use this though. Packaging in background sometimes causes layers not correctly rendered.
    ///
    /// - tvOS11
    ///     On tvOS11, things are little complicated.
    ///     An overlay can be defined as "image" (`needsRendering = true`), "view", or "layer".
    ///     Note that there isn't a way to keep correct order between "image" and "view".
    ///     Images are rendered into single image. We can keep order between views and layers.
    ///
    /// - tvOS10 or earlier
    ///     On tvOS10, every overlays are rendered as "image", regardless of `needsRendering` definition.
    public func addOverlays(with image: UIImage, overlays: [OverlayProtocol], imagePackagingQueue: DispatchQueue? = nil) {

        let size = base.bounds.size

        if #available(tvOS 11.0, *) {
            // Get overlays defined as "image" (needsRendering), not UIView or CALayer.
            let layersAsImage = overlays
                .filter { $0.needsRendering }
                .flatMap { $0.layers }

            layersAsImage.forEach { $0.sublayers?.forEach { s in s.applySuperLayersBoundsOriginRecursively() } }

            let overlaysAsOverlays = overlays.filter { !$0.needsRendering }

            if layersAsImage.isEmpty {

                // If all overlays are defined as UIView or CALayer,
                // just use `contentOverlayView` in ordinary manner.
                base.addOverlays(overlays: overlaysAsOverlays, image: image)

            } else {

                // - Convert image overlays to images
                // - Pass view/layer overlays to base.addOverlays
                if let queue = imagePackagingQueue {
                    queue.async {
                        guard let packaged = image.packaged(layers: layersAsImage, size: size) else {
                            return
                        }
                        DispatchQueue.main.async {
                            self.base.addOverlays(overlays: overlaysAsOverlays, image: packaged)
                        }
                    }
                } else {
                    guard let packaged = image.packaged(layers: layersAsImage, size: size) else {
                        return
                    }
                    self.base.addOverlays(overlays: overlaysAsOverlays, image: packaged)
                }
            }
        } else {

            let layers: [CALayer] = overlays.flatMap { $0.layers }

            layers.forEach { $0.sublayers?.forEach { s in s.applySuperLayersBoundsOriginRecursively() } }

            // NOTE: packaged(layers:size) don't have to be on main thread,
            //   but it sometimes causes issues like CATextLayer not rendered.
            //   So we're not dispatching on background by default.
            if let queue = imagePackagingQueue {
                queue.async {
                    guard let packaged = image.packaged(layers: layers, size: size) else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.base.image = packaged
                    }
                }
            } else {
                guard let packaged = image.packaged(layers: layers, size: size) else {
                    return
                }
                self.base.image = packaged
            }
        }
    }

    // Disabling this for now.
    // public var overlayContentView: UIView? {
    //     set {
    //         objc_setAssociatedObject(self, &AssociatedKeys.overlayContentView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    //         if base.image == nil, newValue != nil {
    //             assertionFailure("Set image before setting overlayContentView")
    //         }
    //         if let image = base.image, let view = newValue {
    //             addOverlays(with: image, overlays: [AnyViewAsOverlay(view: view)])
    //         }
    //     }
    //     get {
    //         return objc_getAssociatedObject(self, &AssociatedKeys.overlayContentView) as? UIView
    //     }
    // }
}

extension UIImageView {

    private struct AssociatedKeys {
        static var _childOverlayView = "ImageOverlay.UIImageView._childOverlayView"
    }

    var _childOverlayView: UIView? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys._childOverlayView, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys._childOverlayView) as? UIView
        }
    }

    @available(tvOS 11.0, *)
    func addOverlays(overlays: [OverlayProtocol], image: UIImage) {

        let v = self.overlayContentView

        self.image = image

        if let existing = _childOverlayView {

            // Can happen even when clearOverlays is called on prepareForReuse.
            // Because addOverlays can be called asynchronously.
            existing.removeFromSuperview()
        }

        let child = UIView(frame: v.bounds)

        for overlay in overlays {

            if let viewOverlay = overlay as? OverlayViewProtocol {

                if !viewOverlay.needsRendering {
                    child.addSubview(viewOverlay.view)
                }

            } else {

                if !overlay.needsRendering {

                    let layers = overlay.layers

                    layers.forEach {
                        $0.frame = $0.bounds
                        $0.sublayers?.forEach { s in s.applySuperLayersBoundsOriginRecursively() }
                    }

                    layers.forEach {
                        child.layer.addSublayer($0)
                    }
                }
            }
        }

        v.addSubview(child)

        _childOverlayView = child
    }
}

extension UIImage {

    func packaged(layers: [CALayer], size _size: CGSize) -> UIImage? {

        let scaledSize = _size.scaled(2)
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: scaledSize))

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, UIScreen.main.scale)

        if let context = UIGraphicsGetCurrentContext() {
            self.draw(in: rect)
            for layer in layers {
                layer.render(in: context)
            }
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return image
    }
}
