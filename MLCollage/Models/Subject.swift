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
    func modify(mod: Modification, backgroundSize: CGSize) -> Subject {
        var temp = self
        
        ///
        let sourceImage = temp.image
        let resizeFilter = CIFilter(name:"CILanczosScaleTransform")!

        // Desired output size
        let targetSize = CGSize(width: 50, height: backgroundSize.height/2)

        // Compute scale and corrective aspect ratio
        let scale = targetSize.height / (sourceImage.extent.height)

        // Apply resizing
        resizeFilter.setValue(sourceImage, forKey: kCIInputImageKey)
        resizeFilter.setValue(scale, forKey: kCIInputScaleKey)
        let outputImage = resizeFilter.outputImage
        temp.image = outputImage!
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


