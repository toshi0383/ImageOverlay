//
//  Utilities.swift
//  ImageOverlayTests
//
//  Created by Toshihiro Suzuki on 2017/11/12.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import AVFoundation
import UIKit

extension UIImage {
    func dump(file: String = #file, function: String = #function, name: String) {
        let testFileName = file.replacingOccurrences(of: ".swift", with: "").split(separator: "/").last!
        let testCaseName = function.replacingOccurrences(of: "()", with: "")
        let data = imageToData(self)
        let dir = NSTemporaryDirectory()
        let path = "\(dir)\(testFileName)_\(testCaseName)_\(name).png"
        print(path)
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
}

func imageToData(_ image: UIImage?) -> Data? {
    guard let image = image else {
        return nil
    }
    return UIImagePNGRepresentation(image)
}

func render(_ layers: [CALayer]) -> UIImage? {
    let size = CGSize(width: 50, height: 50)
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    if let context = UIGraphicsGetCurrentContext() {
        for layer in layers {
            layer.render(in: context)
        }
    }
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

func render(_ layers: [CALayer], image: UIImage) -> UIImage? {
    let size = image.size
    let rect = AVMakeRect(aspectRatio: CGSize(width: 16, height: 9), insideRect: CGRect(origin: .zero, size: size))
    UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
    if let context = UIGraphicsGetCurrentContext() {
        image.draw(in: rect)
        for layer in layers {
            layer.render(in: context)
        }
    }
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}
