//
//  Scale.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import Foundation

public enum Scale {
    public static var value: CGFloat {
        if #available(tvOS 11.0, *) {
            return 1
        } else {
            return 2
        }
    }
}
