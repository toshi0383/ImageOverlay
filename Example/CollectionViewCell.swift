//
//  CollectionViewCell.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import ImageOverlay
import UIKit

struct ViewAsOverlay: OverlayViewProtocol {
    let needsRendering: Bool = true
    var view: UIView {
        let frame = CGRect(x: 100.25, y: 0, width: 200, height: 112.5)
        let v = UIView(frame: frame)
        v.backgroundColor = .red
        v.alpha = 0.3
        let child = UIView()
        child.backgroundColor = .blue
        child.translatesAutoresizingMaskIntoConstraints = false
        v.addSubview(child)
        NSLayoutConstraint.activate([
            child.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            child.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            child.widthAnchor.constraint(equalToConstant: 50),
            child.heightAnchor.constraint(equalToConstant: 50),
        ])
        return v
    }
}

final class CollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.contentMode = .scaleAspectFit
            imageView.adjustsImageWhenAncestorFocused = true
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.io.clearOverlays()
    }
    func configureWithView() {
        let image = UIImage(named: "Italy1")!
        let overlays: [OverlayProtocol] = [ViewAsOverlay()]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
    func configureWithBuiltInProtocols() {
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
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
}
