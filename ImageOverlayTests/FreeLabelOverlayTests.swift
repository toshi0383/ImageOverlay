//
//  FreeLabelOverlayTests.swift
//  ImageOverlayTests
//
//  Created by Toshihiro Suzuki on 2017/11/11.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import XCTest

class FreeLabelOverlayTests: XCTestCase {

    func testLayers() {
        let o = FreeLabelOverlay(text: "Free", height: 225, y: 171)
        let layers = o.layers
        let layer = layers[0]
        let child = layer.sublayers![0]
        if #available(tvOS 11.0, *) {
            XCTAssertEqual(layer.bounds.origin, CGPoint(x: 0, y: 171))
            XCTAssertEqual(child.frame.origin, CGPoint(x: 8, y: 5))
        } else {
            XCTAssertEqual(layer.bounds.origin, CGPoint(x: 0, y: 342))
            XCTAssertEqual(child.frame.origin, CGPoint(x: 16, y: 10))
        }
    }
}
