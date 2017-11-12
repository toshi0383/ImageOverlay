//
//  OverlayViewProtocol.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation

public protocol OverlayViewProtocol: OverlayProtocol {
    var view: UIView { get }
}

extension OverlayViewProtocol {
    // TODO: Needs test for scaling
    // Layers are copied by default here.
    // Otherwise scaled frame would conflict with autolayout, right?
    public var layers: [CALayer] {
        var layers = view.getLayersRecursively()
        if #available(tvOS 11.0, *) {
            if needsRendering {
                layers[0].scaleBounds(2)
                layers.dropFirst().forEach { $0.scaleBounds(2) }
            }
        } else {
            layers[0].scaleBounds(2)
            layers.dropFirst().forEach { $0.scaleBounds(2) }
        }
        return layers
    }
}

extension UIView {
    func getLayersRecursively() -> [CALayer] {
        // NOTE: This recursive layoutIfNeeded() is required.
        //   Children's frame aren't updated by parent's layoutIfNeeded()
        layoutIfNeeded()

        var baseLayer: [CALayer] = []
        if superview == nil {
            let layer = self.layer
            layer.bounds = self.frame
            baseLayer.append(layer)
        }
        let childLayers = subviews.map { $0.layer }
        childLayers.forEach { $0.bounds = CGRect(x: self.frame.minX + $0.frame.origin.x,
                                                y: self.frame.minY + $0.frame.origin.y,
                                                width: $0.frame.width,
                                                height: $0.frame.height) }
        // TODO: Call recursively
        return baseLayer + childLayers
    }
}

extension CALayer {
    func scaleBounds(_ scale: CGFloat) {
        bounds = CGRect(origin: bounds.origin.scaled(scale), size: bounds.size.scaled(scale))
    }
    func scaleFrame(_ scale: CGFloat) {
        frame = CGRect(origin: frame.origin.scaled(scale), size: frame.size.scaled(scale))
    }
    func applySuperLayersBoundsOriginRecursively() {
        guard let parent = superlayer else {
            fatalError("Use this method for sublayers only.")
        }
        frame = frame.offsetBy(dx: parent.bounds.minX, dy: parent.bounds.minY)
        sublayers?.forEach { $0.applySuperLayersBoundsOriginRecursively() }
    }
}
