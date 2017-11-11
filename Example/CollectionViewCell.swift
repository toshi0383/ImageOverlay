//
//  CollectionViewCell.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/09.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import ImageOverlay
import UIKit

/// On tvOS10 or earlier, this is treated as ViewAsImage anyways.
struct ViewAsOverlay: OverlayViewProtocol {
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

/// Set needsRendering to true if you want this view rendered as UIImage on tvOS11
struct ViewAsImage: OverlayViewProtocol {
    let needsRendering: Bool = true
    var view: UIView {
        let frame = CGRect(x: 0, y: 190, width: 400, height: 35)
        let v = UIView(frame: frame)
        v.backgroundColor = .green
        v.alpha = 0.4
        let child = UIView(frame: CGRect(x: 100, y: 8.75, width: 200, height: 17.5))
        child.backgroundColor = .white
        child.alpha = 1.0
        v.addSubview(child)
        return v
    }
}

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
        let image = UIImage(named: "Italy1")!
        switch indexPath.item % 3 {
        case 0:
            configureWithViewAsImage(image: image)
        case 1:
            configureWithViewAsOverlay(image: image)
        // case 2:
        //     configureWithContentOverlayViewProperty(image: image)
        default:
            configureWithBuiltInProtocols(image: image, indexPath: indexPath)
        }
    }
    private func configureWithViewAsImage(image: UIImage) {
        let overlays: [OverlayProtocol] = [ViewAsImage()]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
    private func configureWithViewAsOverlay(image: UIImage) {
        let overlays: [OverlayProtocol] = [ViewAsOverlay()]
        imageView.io.addOverlays(with: image, overlays: overlays)
    }
     // private func configureWithContentOverlayViewProperty(image: UIImage) {
     //     imageView.image = image
     //     imageView.io.overlayContentView = ViewAsOverlay().view
     // }
    private func configureWithBuiltInProtocols(image: UIImage, indexPath: IndexPath) {
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
}
