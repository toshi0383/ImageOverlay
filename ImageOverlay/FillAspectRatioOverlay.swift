//
//  FillAspectRatioOverlay.swift
//  ImageOverlay
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVFoundation
import Foundation

public struct FillAspectRatioOverlay: OverlayProtocol {
    public let layers: [CALayer]
    public let needsRendering: Bool = true
    public init(image: UIImage, size: CGSize) {
        let scaledSize = size.scaled(2) // scale is always 2 when needsRendering is true
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: .zero, size: scaledSize))
        self.layers = _blackLayers(imageRect: rect, targetSize: scaledSize)
    }
}

private func _blackLayers(imageRect rect: CGRect, targetSize: CGSize) -> [CALayer] {
    if rect.width < targetSize.width {
        let width = ceil(rect.minX)
        return [0, targetSize.width - width].map { (x: CGFloat) in
            let horizontalFiller = CALayer()
            horizontalFiller.backgroundColor = UIColor.black.cgColor
            horizontalFiller.frame = CGRect(x: x, y: 0, width: width, height: targetSize.height)
            return horizontalFiller
        }
    } else if rect.height < targetSize.height {
        let height = ceil(rect.minY)
        return [0, targetSize.height - height].map { (y: CGFloat) in
            let verticalFiller = CALayer()
            verticalFiller.backgroundColor = UIColor.black.cgColor
            verticalFiller.frame = CGRect(x: 0, y: y, width: targetSize.width, height: height)
            return verticalFiller
        }
    }
    return []
}
