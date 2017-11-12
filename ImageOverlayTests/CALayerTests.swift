//
//  CALayerTests.swift
//  ImageOverlayTests
//
//  Created by Toshihiro Suzuki on 2017/11/12.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import XCTest

@testable import ImageOverlay

class CALayerTests: XCTestCase {

    private var layer: CALayer!
    private var child: CALayer!
    override func setUp() {
        super.setUp()
        layer = CALayer()
        layer.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        child = CATextLayer()
        child.frame = CGRect(x: 7.5, y: 7.5, width: 15, height: 15)
        layer.addSublayer(child)
    }
    func testNestedLayer() {
        XCTAssertEqual(layer.position, CGPoint(x: 25, y: 25))
        XCTAssertEqual(layer.bounds, CGRect(x: 0, y: 0, width: 30, height: 30))
        XCTAssertEqual(layer.frame, CGRect(x: 10, y: 10, width: 30, height: 30))
        XCTAssertEqual(child.position, CGPoint(x: 15, y: 15))
        XCTAssertEqual(child.bounds, CGRect(x: 0, y: 0, width: 15, height: 15))
        XCTAssertEqual(child.frame, CGRect(x: 7.5, y: 7.5, width: 15, height: 15))
    }
    func testNestedScaledLayer() {
        layer.scale(2)
        child.scale(2)
        XCTAssertEqual(layer.position, CGPoint(x: 50, y: 50))
        XCTAssertEqual(layer.bounds, CGRect(x: 0, y: 0, width: 60, height: 60))
        XCTAssertEqual(layer.frame, CGRect(x: 20, y: 20, width: 60, height: 60))
        XCTAssertEqual(child.position, CGPoint(x: 30, y: 30))
        XCTAssertEqual(child.bounds, CGRect(x: 0, y: 0, width: 30, height: 30))
        XCTAssertEqual(child.frame, CGRect(x: 15, y: 15, width: 30, height: 30))
    }
}
