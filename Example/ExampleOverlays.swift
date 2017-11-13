//
//  ExampleOverlays.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/13.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation
import ImageOverlay

struct ViewAsImage: OverlayViewProtocol {
    let needsRendering: Bool = true
    var view: UIView {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 225)
        let v = UIView(frame: frame)
        v.backgroundColor = .red
        v.alpha = 0.3
        let child = UIView(frame: CGRect(x: 150, y: 62.5, width: 100, height: 100))
        child.backgroundColor = .blue
        child.alpha = 1.0
        v.addSubview(child)
        return v
    }
}

/// On tvOS10 or earlier, this is treated as ViewAsImage anyways.
/// Set needsRendering to true if you want this view rendered as UIImage on tvOS11.
///
/// NOTE: child.alpha = 1.0 but it's appears 0.4 on screen. That's how UIView(CALayer) works.
///   If you want child to appear alpha 1.0, don't addSublayer to parent view,
///   instead consider implementing `layers: [CALayer]` property of this protocol,
///   and return layers separatedly.
struct ViewAsOverlay: OverlayViewProtocol {
    var view: UIView {
        let frame = CGRect(x: 0, y: 0, width: 400, height: 225)
        let v = UIView(frame: frame)
        v.backgroundColor = .red
        v.alpha = 0.3
        let child = UIView()
        child.alpha = 1.0
        child.backgroundColor = .blue
        child.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(child)
        NSLayoutConstraint.activate([
            child.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            child.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            child.widthAnchor.constraint(equalToConstant: 100),
            child.heightAnchor.constraint(equalToConstant: 100),
            ])
        return v
    }
}
