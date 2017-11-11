//
//  OverlayProtocol.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation

public enum FocusStatus {
    case always
    // Not supported yet.
    // case focused, notFocused,
}

public protocol OverlayProtocol {
    var layers: [CALayer] { get }
    var focusStatus: FocusStatus { get }

    var needsRendering: Bool { get }
}

extension OverlayProtocol {
    public var needsRendering: Bool {
        if #available(tvOS 11.0, *) {
            return false
        } else {
            return true
        }
    }
    public var focusStatus: FocusStatus {
        return .always
    }
}

