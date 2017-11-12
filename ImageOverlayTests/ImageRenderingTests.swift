//
//  ImageRenderingTests.swift
//  ImageOverlayTests
//
//  Created by Toshihiro Suzuki on 2017/11/12.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import XCTest

@testable import ImageOverlay

class ImageRenderingTests: XCTestCase {
    private var parentView: UIView! {
        didSet {
            parentView.backgroundColor = .red
            parentView.alpha = 0.5
        }
    }
    private var childView: UIView! {
        didSet {
            childView.backgroundColor = .blue
            childView.alpha = 1.0
        }
    }
    private var parentLayer: CALayer! {
        didSet {
            parentLayer.backgroundColor = UIColor.red.cgColor
            parentLayer.opacity = 0.5
        }
    }
    private var childLayer: CALayer! {
        didSet {
            childLayer.backgroundColor = UIColor.blue.cgColor
            childLayer.opacity = 1.0
        }
    }
    
    override func setUp() {
        super.setUp()
        parentView = UIView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        childView = UIView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        parentView.addSubview(childView)
        parentLayer = CALayer()
        parentLayer.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        childLayer = CATextLayer()
        childLayer.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        parentLayer.addSublayer(childLayer)
    }
    
    override func tearDown() {
        childView.removeFromSuperview()
        childLayer.removeFromSuperlayer()
        super.tearDown()
    }

    func testRenderLayers() {
        let layersFromView = [parentView.layer]
        let layers = [parentLayer!]
        do {
            let images = [layers, layersFromView].flatMap(render)
            images.enumerated().forEach { $0.1.dump(name: "\($0.0)") }
        }
        XCTAssertEqual(imageToData(render(layers)), imageToData(render(layersFromView)))
    }

    func testRenderWithImage() {
        guard let url = Bundle(for: ImageRenderingTests.self).url(forResource: "Italy1", withExtension: "jpg"),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
                XCTFail()
                return
        }

        // double squares at center
        parentView.bounds = CGRect(x: 225, y: 100, width: 300, height: 300)
        childView.frame = CGRect(x: 75, y: 75, width: 150, height: 150)
        parentLayer.bounds = CGRect(x: 225, y: 100, width: 300, height: 300)
        childLayer.frame = CGRect(x: 75, y: 75, width: 150, height: 150)

        childView.layer.applySuperLayersBoundsOrigin()
        childLayer.applySuperLayersBoundsOrigin()

        let layersFromView = [parentView.layer]
        let layers = [parentLayer!]
        let imageFromLayer = render(layers, image: image)
        let imageFromView = render(layersFromView, image: image)
        do {
            let images = [imageFromLayer, imageFromView].flatMap { $0 }
            images.enumerated().forEach { $0.1.dump(name: "\($0.0)") }
            let datas = images.flatMap(imageToData)
            XCTAssertEqual(datas[0], datas[1])
        }
    }
}
