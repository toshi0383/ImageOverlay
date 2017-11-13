//
//  CollectionViewCell.swift
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
            imageView.clipsToBounds = false // IMPORTANT!
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.io.clearOverlays()
    }
    func configure(indexPath: IndexPath) {
        switch indexPath.item % 4 {
        case 0:
            configureWithViewAsImage()
        case 1:
            configureWithViewAsOverlay()
        case 2:
            configureWithFreeLabel()
        default:
            configureWithBuiltInOverlays(indexPath: indexPath)
        }
    }
    private func configureWithViewAsImage() {
        let image = UIImage(named: "High Sierra")!
        let overlays: [OverlayProtocol] = [ViewAsImage()]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
    private func configureWithViewAsOverlay() {
        let image = UIImage(named: "High Sierra")!
        let overlays: [OverlayProtocol] = [ViewAsOverlay()]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
    private func configureWithFreeLabel() {
        let image = UIImage(named: "High Sierra")!
        let overlays: [OverlayProtocol] = [FreeLabelOverlay(text: "Free", height: 225, y: 171)]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
    private func configureWithBuiltInOverlays(indexPath: IndexPath) {
        let image = UIImage(named: "Italy1")!
        let size = imageView.bounds.size
        let blackFillOverlay = FillAspectRatioOverlay(image: image, size: size)
        let gradientStartY: CGFloat = 0.6
        let colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0),
                      UIColor(red: 0, green: 0, blue: 0, alpha: 1)]
        let alphaOverlay = AlphaGradientOverlay(size: size, position: .bottom(gradientStartY: gradientStartY), colors: colors)
        let textOrigin = CGPoint(x: 16, y: imageView.frame.height - 22 - 22)
        let textOverlay = TextOverlay(text: "CATCHUP: #\(indexPath.item)", font: UIFont.boldSystemFont(ofSize: 22), foregroundColor: .white, size: size, textOrigin: textOrigin)
        let overlays: [OverlayProtocol] = [blackFillOverlay, alphaOverlay, textOverlay]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if context.nextFocusedView == self {
            self.layer.zPosition = 0.1
        } else {
            self.layer.zPosition = 0.0
        }
        super.didUpdateFocus(in: context, with: coordinator)
    }
}
