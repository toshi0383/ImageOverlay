//
//  AnyViewAsOverlayTests.swift
//  ImageOverlayTests
//
//  Created by Toshihiro Suzuki on 2017/11/10.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import XCTest

@testable import ImageOverlay

class AnyViewAsOverlayTests: XCTestCase {
    private var parent: UIView!
    private var layers: [CALayer] = []
    override func setUp() {
        super.setUp()
        parent = UIView(frame: CGRect(x: 10, y: 10, width: 11, height: 11))
    }
    func validateParent() {
        guard let layer = layers.first else {
            XCTFail()
            return
        }
        if #available(tvOS 11.0, *) {
            XCTAssertEqual(layer.position, CGPoint(x: 15.5, y: 15.5))
            XCTAssertEqual(layer.bounds, CGRect(x: 0, y: 0, width: 11, height: 11))
            XCTAssertEqual(layer.frame, CGRect(x: 10, y: 10, width: 11, height: 11))
        } else {
            XCTAssertEqual(layer.position, CGPoint(x: 31, y: 31))
            XCTAssertEqual(layer.bounds, CGRect(x: 0, y: 0, width: 22, height: 22))
            XCTAssertEqual(layer.frame, CGRect(x: 20, y: 20, width: 22, height: 22))
        }
    }
    func testSingleView() {
        let view = UIView(frame: CGRect(x: 10, y: 10, width: 11, height: 11))
        let o = AnyViewAsOverlay(view: view)
        layers = o.layers
        XCTAssertEqual(layers.count, 1)
        validateParent()
    }

    func testChildView() {
        let view = UIView(frame: CGRect(x: 10, y: 10, width: 11, height: 11))
        let child = UIView(frame: CGRect(x: 2, y: 2, width: 7, height: 7))
        view.addSubview(child)
        let o = AnyViewAsOverlay(view: view)
        layers = o.layers
        XCTAssertEqual(layers.count, 2)
        validateParent()
        guard let layer = layers.last else {
            XCTFail()
            return
        }
        if #available(tvOS 11.0, *) {
            XCTAssertEqual(layer.position, CGPoint(x: 15.5, y: 15.5))
            XCTAssertEqual(layer.bounds, CGRect(x: 0, y: 0, width: 7, height: 7))
            XCTAssertEqual(layer.frame, CGRect(x: 12, y: 12, width: 7, height: 7))
        } else {
            XCTAssertEqual(layer.position, CGPoint(x: 31, y: 31))
            XCTAssertEqual(layer.bounds, CGRect(x: 0, y: 0, width: 14, height: 14))
            XCTAssertEqual(layer.frame, CGRect(x: 24, y: 24, width: 14, height: 14))
        }
    }
}
