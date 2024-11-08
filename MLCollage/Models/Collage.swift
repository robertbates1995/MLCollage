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

class Collage: Identifiable {
    let id = UUID()
    var image: CIImage
    var annotations: [CollageData.Annotation]
    
    init(image: CIImage, annotations: [CollageData.Annotation]) {
        self.image = image
        self.annotations = annotations
    }
}

//CIImage for manipulation
//UIImage for ios
//NSImage for mac
