//
//  ImageOverlay.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVFoundation
import UIKit

extension UIImageView: NameSpaceCompatible { }

extension NameSpace where Base: UIImageView {
    public func addOverlay(to image: UIImage, text: String? = nil) {
        if #available(tvOS 11.0, *) {
            base.addOverlayContentView(image: image, text: text)
        } else {
            let size = base.bounds.size
            DispatchQueue.global().async {
                guard let packaged = image.packaged(text: "CATCHUP", _size: size, scale: 2) else {
                    return
                }
                DispatchQueue.main.async {
                    self.base.image = packaged
                }
            }
        }
    }
}

extension UIImageView {
    @available(tvOS 11.0, *)
    func addOverlayContentView(image: UIImage, text: String? = nil) {
        let layers = image.getLayers(text: text, _size: bounds.size, scale: 1)
        let v = self.overlayContentView
        self.image = image
        self.clipsToBounds = false
        v.clipsToBounds = false
        layers.forEach {
            v.layer.addSublayer($0)
        }
    }
}

extension UIImage {
    fileprivate func getLayers(text: String?, _size: CGSize, scale: CGFloat) -> [CALayer] {
        let textLayers = _textLayers(text: text, targetSize: _size, scale: scale)
        let scaledSize = CGSize(width: _size.width * scale, height: _size.height * scale)
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: scaledSize))
        let blackLayers: [CALayer] = self.size.isAspectRatio16_9 ? [] : _blackLayers(imageRect: rect, targetSize: scaledSize)
        return blackLayers + textLayers
    }
    fileprivate func packaged(text: String?, _size: CGSize, scale: CGFloat) -> UIImage? {
        let layers = getLayers(text: text, _size: _size, scale: scale)
        let __size = CGSize(width: _size.width * scale, height: _size.height * scale)
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: __size))
        UIGraphicsBeginImageContextWithOptions(__size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            self.draw(in: rect)
            for layer in layers {
                layer.render(in: context)
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    private func _blackLayers(imageRect rect: CGRect, targetSize: CGSize) -> [CALayer] {
        if rect.width < targetSize.width {
            let width = ceil(rect.minX)
            return [0, targetSize.width - width].map { (x: CGFloat) in
                let horizontalFiller = CALayer()
                horizontalFiller.backgroundColor = UIColor.black.cgColor
                horizontalFiller.bounds = CGRect(x: x, y: 0, width: width, height: targetSize.height)
                return horizontalFiller
            }
        } else if rect.height < targetSize.height {
            let height = ceil(rect.minY)
            return [0, targetSize.height - height].map { (y: CGFloat) in
                let verticalFiller = CALayer()
                verticalFiller.backgroundColor = UIColor.black.cgColor
                verticalFiller.bounds = CGRect(x: 0, y: y, width: targetSize.width, height: height)
                return verticalFiller
            }
        }
        return []
    }
}

// グラデーション背景のレイヤーとテキストレイヤー
// opacityがparentに引っ張られるためaddSublayerはせずに2つ別々に返す.
private func _textLayers(text: String?, targetSize _size: CGSize, scale: CGFloat) -> [CALayer] {
    guard let text = text else { return [] }
    let size = CGSize(width: _size.width * scale, height: _size.height * scale)
    // alpha layer
    let layer = CAGradientLayer()
    let gradientStartY: CGFloat = 134.0/225.0
    layer.colors = [
        UIColor(red: 0, green: 0, blue: 0, alpha: 0),
        UIColor(red: 0, green: 0, blue: 0, alpha: 0),
        UIColor(red: 0, green: 0, blue: 0, alpha: gradientStartY),
        UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        ].map { $0.cgColor }
    layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    // textLayer
    let font = UIFont.boldSystemFont(ofSize: 22.0 * scale)
    let textSize = NSString(string: text).size(withAttributes: [NSAttributedStringKey.font: font])
    let textLayer = CATextLayer()
    textLayer.string = text
    textLayer.font = font
    textLayer.fontSize = font.pointSize
    textLayer.foregroundColor = UIColor.white.cgColor
    let layerRect = layer.bounds
    let x = layerRect.minX + 16 * scale
    let y = layerRect.maxY - 14.5 * scale - textSize.height
    textLayer.frame = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
    textLayer.alignmentMode = kCAAlignmentCenter
    textLayer.contentsScale = UIScreen.main.scale
    let _layer = CALayer()
    _layer.backgroundColor = UIColor.clear.cgColor
    _layer.bounds = layer.bounds
    _layer.contentsScale = UIScreen.main.scale
    _layer.addSublayer(textLayer)

    return [layer, _layer]
}

extension CGSize {
    fileprivate var isAspectRatio16_9: Bool {
        func gcd(_ a: CGFloat, _ b: CGFloat) -> CGFloat {
            let r = a.truncatingRemainder(dividingBy: b)
            if r != 0 {
                return gcd(b, r)
            } else {
                return b
            }
        }
        let _gcd = gcd(self.width, self.height)
        return (self.width / _gcd, self.height / _gcd) == (16, 9)
    }
}
