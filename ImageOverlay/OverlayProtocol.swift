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
}

public protocol OverlayLayerProtocol: OverlayProtocol { }
