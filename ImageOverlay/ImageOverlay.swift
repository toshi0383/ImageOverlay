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
    public func setImage(_ image: UIImage, overlays: [OverlayProtocol]) {
        let layers = overlays.flatMap { $0.layers }
        if #available(tvOS 11.0, *) {
            base.addOverlays(layers: layers, image: image)
        } else {
            let size = base.bounds.size
            DispatchQueue.global().async {
                guard let packaged = image.packaged(layers: layers, size: size) else {
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
    func addOverlays(layers: [CALayer], image: UIImage) {
        let v = self.overlayContentView
        self.image = image
        self.clipsToBounds = false
        v.clipsToBounds = false
        layers.forEach {
            $0.frame = CGRect(origin: $0.bounds.origin, size: $0.bounds.size)
            v.layer.addSublayer($0)
        }
    }
}

extension UIImage {
    fileprivate func packaged(layers: [CALayer], size _size: CGSize) -> UIImage? {
        let scaledSize = _size.scaled(2)
        let rect = AVMakeRect(aspectRatio: self.size, insideRect: CGRect(origin: .zero, size: scaledSize))
        UIGraphicsBeginImageContextWithOptions(scaledSize, false, UIScreen.main.scale)
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
}

