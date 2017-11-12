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
        layer.bounds = CGRect(x: 10, y: 10, width: 30, height: 30)
        layer.backgroundColor = UIColor.red.cgColor
        layer.opacity = 0.3
        child = CATextLayer()
        child.frame = CGRect(x: 7.5, y: 7.5, width: 15, height: 15)
        child.backgroundColor = UIColor.blue.cgColor
        layer.addSublayer(child)
    }
    func testNestedLayerOpacity() {
        let c = CALayer()
        c.opacity = 1.0
        child.addSublayer(c)
        c.backgroundColor = UIColor.black.cgColor
        c.frame = CGRect(x: 7.5, y: 7.5, width: 15, height: 15)
        XCTAssertEqual(layer.opacity, 0.3)
        XCTAssertEqual(child.opacity, 1.0)
        XCTAssertEqual(c.opacity, 1.0)
        render([layer])?.dump(name: "opacity")
    }
    func testNestedLayer() {
        XCTAssertEqual(layer.position, CGPoint(x: 0, y: 0))
        XCTAssertEqual(layer.bounds, CGRect(x: 10, y: 10, width: 30, height: 30))
        XCTAssertEqual(layer.frame, CGRect(x: -15, y: -15, width: 30, height: 30))
        XCTAssertEqual(child.position, CGPoint(x: 15, y: 15))
        XCTAssertEqual(child.bounds, CGRect(x: 0, y: 0, width: 15, height: 15))
        XCTAssertEqual(child.frame, CGRect(x: 7.5, y: 7.5, width: 15, height: 15))
    }
    func testNestedScaledLayer() {
        layer.scaleBounds(2)
        child.scaleFrame(2)
        XCTAssertEqual(layer.position, CGPoint(x: 0, y: 0))
        XCTAssertEqual(layer.bounds, CGRect(x: 20, y: 20, width: 60, height: 60))
        XCTAssertEqual(layer.frame, CGRect(x: -30, y: -30, width: 60, height: 60))
        XCTAssertEqual(child.position, CGPoint(x: 30, y: 30))
        XCTAssertEqual(child.bounds, CGRect(x: 0, y: 0, width: 30, height: 30))
        XCTAssertEqual(child.frame, CGRect(x: 15, y: 15, width: 30, height: 30))
    }
}
