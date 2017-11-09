//
//  CollectionVIewCell.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import ImageOverlay
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
            imageView.adjustsImageWhenAncestorFocused = true
        }
    }
    func configure() {
        let image = UIImage(named: "Italy1")!
        let size = imageView.bounds.size
        let blackFillOverlay = FillAspectRatioOverlay(image: image, size: size)
        let gradientStartY: CGFloat = 0.6
        let colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0),
                      UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let alphaOverlay = AlphaGradientOverlay(size: size, position: .bottom(gradientStartY: gradientStartY), colors: colors)
        let textOrigin = CGPoint(x: 16, y: imageView.frame.height - 22 - 22)
        let textOverlay = TextOverlay(text: "CATCHUP", font: UIFont.boldSystemFont(ofSize: 22), foregroundColor: .white, size: size, textOrigin: textOrigin)
        let overlays: [OverlayProtocol] = [blackFillOverlay, alphaOverlay, textOverlay]
        imageView.io.setImage(image, overlays: overlays)
    }
}
