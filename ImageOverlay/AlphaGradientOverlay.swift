//
//  AlphaGradientOverlay.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation

public struct AlphaGradientOverlay: OverlayProtocol {
    public let layers: [CALayer]
    public let needsRendering: Bool = true
    public enum Position {
        case bottom(gradientStartY: CGFloat)
    }
    public init(size: CGSize, position: Position, colors: [UIColor]) {
        guard case .bottom(let gradientStartY) = position else {
            fatalError()
        }
        // alpha layer
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: gradientStartY)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.colors = colors.map { $0.cgColor }
        let scaledSize = size.scaled(2)
        layer.bounds = CGRect(origin: .zero, size: scaledSize)
        self.layers = [layer]
    }
}
