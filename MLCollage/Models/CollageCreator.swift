//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
import SwiftUI
#endif

class CollageCreator {
    func create(subject: Subject, background: CIImage, title: String) -> Collage {
        //create one annotation and one Collage in this step
        var collage = background
        var annotations = [CollageData.Annotation]()
        collage = subject.image.composited(over: background).cropped(to: background.extent)
        annotations.append(CollageData.Annotation(label: subject.label, coordinates: .init(subject.image.extent)))
        let data = CollageData(annotation: annotations, title: title)
        return Collage(image: UIImage(ciImage: collage), data: data)
    }
}

#if os(macOS)
typealias ImageType = NSImage
#else
typealias ImageType = UIImage
#endif

class Collage {
    var image: ImageType
    var data: CollageData
    init(image: UIImage, data: CollageData) {
        self.image = image
        self.data = data
    }
}

//CIImage for manipulation
//UIImage for ios
//NSImage for mac
