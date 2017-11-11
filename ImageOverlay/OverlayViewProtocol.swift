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
    public var layers: [CALayer] {
        let layers = view.getLayersRecursively()
        if #available(tvOS 11.0, *) {
            if needsRendering {
                layers.forEach { $0.scale(2) }
            }
        } else {
            layers.forEach { $0.scale(2) }
        }
        return layers
    }
}

extension UIView {
    func getLayersRecursively() -> [CALayer] {
        // NOTE: This recursive layoutIfNeeded() is required.
        //   Children's frame aren't updated by parent's layoutIfNeeded()
        layoutIfNeeded()

        let sublayers = subviews.map { $0.getLayersRecursively() }.flatMap { $0 }
        sublayers.forEach { $0.applySuperLayersFrameOrigin() }
        return [layer] + sublayers
    }
}

extension CALayer {
    func scale(_ scale: CGFloat) {
        let origin = CGPoint(x: position.x - bounds.width / 2, y: position.y - bounds.height / 2)
        frame = CGRect(origin: origin, size: bounds.size).scaled(scale)
    }
    func applySuperLayersFrameOrigin() {
        guard let parent = superlayer else { return }
        frame = frame.offsetBy(dx: parent.frame.minX, dy: parent.frame.minY)
    }
}
