//
//  TextOverlay.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVFoundation
import Foundation

public struct TextOverlay: OverlayProtocol {
    public let layers: [CALayer]
    public init(text: String, font: UIFont, foregroundColor: UIColor = .white, size: CGSize, textOrigin: CGPoint) {
        let textLayer = _textLayer(text: text, font: font, foregroundColor: foregroundColor, origin: textOrigin, size: size, scale: Scale.value)
        self.layers = [textLayer]
    }
}

private func _textLayer(text: String, font: UIFont, foregroundColor: UIColor, origin: CGPoint, size: CGSize, scale: CGFloat) -> CALayer {
    let textSize = NSString(string: text).size(withAttributes: [NSAttributedStringKey.font: font])
    let scaledTextSize = textSize.scaled(scale)
    let scaledOrigin = origin.scaled(scale)
    let textLayer = CATextLayer()
    textLayer.string = text
    textLayer.font = font
    textLayer.fontSize = font.pointSize * scale
    textLayer.foregroundColor = foregroundColor.cgColor
    textLayer.frame = CGRect(origin: scaledOrigin, size: scaledTextSize)
    textLayer.alignmentMode = kCAAlignmentCenter
    textLayer.contentsScale = UIScreen.main.scale
    let _layer = CALayer()
    _layer.bounds = CGRect(origin: .zero, size: size.scaled(scale))
    _layer.backgroundColor = UIColor.clear.cgColor
    _layer.contentsScale = UIScreen.main.scale
    _layer.addSublayer(textLayer)
    return _layer
}
