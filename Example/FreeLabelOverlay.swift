//
//  FreeLabelOverlay.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/11.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import ImageOverlay
import UIKit

struct FreeLabelOverlay: OverlayProtocol {
    let layers: [CALayer]
    init(text: String, height: CGFloat, y: CGFloat) {
        self.layers = [_freeLabelLayer(text: text, height: height, y: y)]
    }
}

private func _freeLabelLayer(text: String, height: CGFloat, y: CGFloat) -> CALayer {
    let font = UIFont.boldSystemFont(ofSize: 22 * Scale.value)
    let textSize = NSString(string: text).size(withAttributes: [NSAttributedStringKey.font: font])
    let scaledOrigin = CGPoint(x: 0, y: y).scaled(Scale.value)
    let insets = UIEdgeInsets(horizontal: 8 * Scale.value, vertical: 5 * Scale.value)
    let layerFrame = CGRect(x: scaledOrigin.x,
                            y: scaledOrigin.y,
                            width: insets.left + textSize.width + insets.right,
                            height: insets.top + textSize.height + insets.bottom)
    let textLayerFrame = CGRect(x: insets.left,
                                y: insets.top,
                                width: textSize.width,
                                height: textSize.height)
    let textLayer = CATextLayer()
    textLayer.frame = textLayerFrame
    textLayer.string = text
    textLayer.font = font
    textLayer.fontSize = font.pointSize
    textLayer.foregroundColor = UIColor.white.cgColor
    textLayer.contentsScale = UIScreen.main.scale
    textLayer.alignmentMode = kCAAlignmentCenter
    let layer = CALayer()
    layer.cornerRadius = 2 * Scale.value
    layer.contentsScale = UIScreen.main.scale
    layer.backgroundColor = UIColor(hex: 0xF0163A).cgColor
    layer.bounds = layerFrame
    layer.addSublayer(textLayer)
    return layer
}
