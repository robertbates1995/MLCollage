////
////  CollageFactory.swift
////  MLCollage
////
////  Created by Robert Bates on 11/8/24.
////
//
//import UIKit
//import CoreImage
//
//struct CollageFactory {
//    let mod: Modification
//    let backgroundSize: CGSize
//    let subject: UIImage
//    
//    static func create(subject: Subject, background: CIImage, title: String) -> Collage {
//        //create one annotation and one Collage in this step
//        var collage = background
//        var annotations = [CollageData.Annotation]()
//        collage = subject.image.composited(over: background).cropped(to: background.extent)
//        annotations.append(CollageData.Annotation(label: subject.label, coordinates: .init(subject.image.extent, backgroundHeight: collage.extent.height)))
//        return Collage(image: collage, annotations: annotations)
//    }
//    
//    //modify must return copy of subject without changing OG
//    func modify() -> Collage {
//        var temp = self
//        
//        ///
//        let sourceImage = temp.image
//        let resizeFilter = CIFilter(name:"CILanczosScaleTransform")!
//
//        // Desired output size
//        let targetSize = CGSize(width: 50, height: backgroundSize.height/2)
//
//        // Compute scale and corrective aspect ratio
//        let scale = targetSize.height / (sourceImage.extent.height)
//
//        // Apply resizing
//        resizeFilter.setValue(sourceImage, forKey: kCIInputImageKey)
//        resizeFilter.setValue(scale, forKey: kCIInputScaleKey)
//        let outputImage = resizeFilter.outputImage
//        temp.image = outputImage!
//        ///
//        
//
//        var extent = temp.image.extent
//        temp.image = temp.image.transformed(by: .init(translationX: -extent.width / 2, y: -extent.height / 2))
//        extent = temp.image.extent
//        temp.image = temp.image.transformed(by: .init(rotationAngle: mod.rotate))
//        extent = temp.image.extent
//        temp.image = temp.image.transformed(by: .init(translationX: extent.width / 2, y: extent.height / 2))
//        extent = temp.image.extent
//        temp.image = temp.image.transformed(by: .init(scaleX: mod.scale, y: mod.scale))
//        extent = temp.image.extent
//        if mod.flipY {
//            temp.image = temp.image.oriented(.downMirrored)
//        }
//        if mod.flipX {
//            temp.image = temp.image.oriented(.upMirrored)
//        }
//        extent = temp.image.extent
//        temp.image = temp.image.transformed(by: .init(translationX: mod.translateX * (backgroundSize.width - extent.width), y: mod.translateY * (backgroundSize.height - extent.height)))
//        return temp
//    }
//}
