//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
import CoreImage
import UIKit
//#if os(macOS)
//import AppKit
//typealias ImageType = NSImage
//#else
//import UIKit
//import SwiftUI
//typealias ImageType = UIImage
//#endif

class Collage {
    var image: CIImage
    var annotations: [CollageData.Annotation]
    
    init(image: CIImage, annotations: [CollageData.Annotation]) {
        self.image = image
        self.annotations = annotations
    }
    
    static func create(subject: Subject, background: CIImage, title: String) -> Collage {
        //create one annotation and one Collage in this step
        var collage = background
        var annotations = [CollageData.Annotation]()
        collage = subject.image.composited(over: background).cropped(to: background.extent)
        annotations.append(CollageData.Annotation(label: subject.label, coordinates: .init(subject.image.extent, backgroundHeight: collage.extent.height)))
        return Collage(image: collage, annotations: annotations)
    }
}

//CIImage for manipulation
//UIImage for ios
//NSImage for mac
