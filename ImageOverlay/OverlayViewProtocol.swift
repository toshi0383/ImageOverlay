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
    public var layers: [CALayer] {
        let layers = view.getLayersRecursively()
        layers.forEach { $0.scaleRecursively() }
        return layers
    }
}

extension UIView {
    func getLayersRecursively() -> [CALayer] {
        layoutIfNeeded()
        let sublayers = subviews.map { $0.getLayersRecursively() }.flatMap { $0 }
        sublayers.forEach { $0.applySuperLayersFrameOrigin() }
        return [layer] + sublayers
    }
}

extension CALayer {
    func scaleRecursively() {
        let origin = CGPoint(x: position.x - bounds.width / 2, y: position.y - bounds.height / 2).scaled(Scale.value)
        frame = CGRect(origin: origin, size: bounds.size.scaled(Scale.value))
        guard let sublayers = sublayers else { return }
        for sublayer in sublayers {
            sublayer.scaleRecursively()
        }
    }
    func applySuperLayersFrameOrigin() {
        guard let parent = superlayer else { return }
        frame = frame.offsetBy(dx: parent.frame.minX, dy: parent.frame.minY)
    }
}
