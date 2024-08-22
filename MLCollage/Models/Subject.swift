//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 8/19/24.
//

import Foundation
import UIKit
import Accelerate

struct Subject {
    var image: CIImage
    var label: String
    init(image: CIImage = CIImage.black, label: String = "subject label") {
        self.image = image
        self.label = label
    }
    
    //modify must return copy of subject without changing OG
    func modify(_ mod: Modification, size: CGSize) -> Subject {
        var temp = self
        var extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: -extent.width / 2, y: -extent.height / 2))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(rotationAngle: mod.rotate))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: extent.width / 2, y: extent.height / 2))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(scaleX: mod.scale, y: mod.scale))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: mod.translateX * (size.width - extent.width), y: mod.translateY * (size.height - extent.height)))
        return temp
    }
}

extension UIImage {
    func toCGImage() -> UIImage {
        guard let ciImage = self.ciImage else {
            return self
        }
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return self
    }
}
