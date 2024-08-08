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

@Observable
class CollageCreator {
    func create(subject: CIImage, background: CIImage, title: String, numberOfSubjects: Int) -> Collage {
        //will likely need parameters to control number of subjects and their orientations
        //create one annotation and one Collage in this step
        let image = subject.composited(over: background).cropped(to: background.extent)
        let annotations = CollageData.Annotation(label: title)
        let data = CollageData(annotations: [annotations], title: title)
        return Collage(image: UIImage(ciImage: image), data: data)
    }
    
    func create(subjects: [(CIImage, String)], background: CIImage, title: String) -> Collage {
        //will likely need parameters to control number of subjects and their orientations
        //create one annotation and one Collage in this step
        var background = background
        var annotations = [CollageData.Annotation]()
        for i in subjects {
            background = i.0.composited(over: background)
            annotations.append(CollageData.Annotation(label: i.1, coordinates: .init(i.0.extent)))
        }
        let data = CollageData(annotations: annotations, title: title)
        return Collage(image: UIImage(ciImage: background), data: data)
    }
}

#if os(OSX)
import AppKit
public typealias View = NSView
public typealias Color = NSColor
public typealias Label = NSTextField

#else
import UIKit
public typealias View = UIView
public typealias Color = UIColor
public typealias Label = UILabel
#endif

class Collage {
    #if os(macOS)
    typealias Image = NSImage
    #else
    typealias Image = UIImage
    #endif
    var image: UIImage
    var data: CollageData
    
    init(image: UIImage, data: CollageData) {
        self.image = image
        self.data = data
    }
}

//CIImage for manipulation
//UIImage for ios
//NSImage for mac
