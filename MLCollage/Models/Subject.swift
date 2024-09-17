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
    var image: CIImage //TODO: convert to array of images all of the same subject
    var label: String //TODO: name of the folder it's sitting in
    init(image: CIImage = CIImage.black, label: String = "subject label") {
        self.image = image
        self.label = label
    }
    
    //modify must return copy of subject without changing OG
    func modify(mod: Modification, backgroundSize: CGSize) -> Subject {
        var temp = self
        
        ///
        let sourceImage = temp.image
        let resizeFilter = CIFilter(name:"CILanczosScaleTransform")!

        // Desired output size
        let targetSize = CGSize(width:100, height:100)

        // Compute scale and corrective aspect ratio
        let scale = targetSize.height / (sourceImage.extent.height)
        let aspectRatio = targetSize.width/((sourceImage.extent.width) * scale)

        // Apply resizing
        resizeFilter.setValue(sourceImage, forKey: kCIInputImageKey)
        resizeFilter.setValue(scale, forKey: kCIInputScaleKey)
        resizeFilter.setValue(aspectRatio, forKey: kCIInputAspectRatioKey)
        let outputImage = resizeFilter.outputImage
        ///

        var extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: -extent.width / 2, y: -extent.height / 2))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(rotationAngle: mod.rotate))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: extent.width / 2, y: extent.height / 2))
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(scaleX: mod.scale, y: mod.scale))
        extent = temp.image.extent
        if mod.flipY {
            temp.image = temp.image.oriented(.downMirrored)
        }
        if mod.flipX {
            temp.image = temp.image.oriented(.upMirrored)
        }
        extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: mod.translateX * (backgroundSize.width - extent.width), y: mod.translateY * (backgroundSize.height - extent.height)))
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
    
    func toCIImage() -> CIImage {
        if let temp = self.ciImage { return temp }
        return CIImage(cgImage: cgImage!)
    }
}
