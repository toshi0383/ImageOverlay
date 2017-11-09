//
//  OverlayProtocol.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation

public protocol OverlayProtocol {
    var layers: [CALayer] { get }

    @available(tvOS 11.0, *)
    var needsRendering: Bool { get }
}

extension OverlayProtocol {
    @available(tvOS 11.0, *)
    public var needsRendering: Bool {
        return false
    }
}

