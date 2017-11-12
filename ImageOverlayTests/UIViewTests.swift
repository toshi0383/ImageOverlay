//
//  UIViewTests.swift
//  ImageOverlayTests
//
//  Created by Toshihiro Suzuki on 2017/11/12.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import XCTest

class UIViewTests: XCTestCase {
    private var parent: UIView!
    private var child: UIView!
    
    override func setUp() {
        super.setUp()
        parent = UIView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        child = UIView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        parent.addSubview(child)
    }
    
    override func tearDown() {
        child.removeFromSuperview()
        super.tearDown()
    }
    
    func testParent() {
        XCTAssertEqual(parent.frame, CGRect(x: 10, y: 10, width: 50, height: 50))
        XCTAssertEqual(parent.layer.bounds, CGRect(x: 0, y: 0, width: 50, height: 50))
        XCTAssertEqual(parent.layer.frame, CGRect(x: 10, y: 10, width: 50, height: 50))
    }

    func testChild() {
        XCTAssertEqual(child.bounds, CGRect(x: 0, y: 0, width: 30, height: 30))
        XCTAssertEqual(child.frame, CGRect(x: 10, y: 10, width: 30, height: 30))
        XCTAssertEqual(child.layer.frame, CGRect(x: 10, y: 10, width: 30, height: 30))
    }
}
