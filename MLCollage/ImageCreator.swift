//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
import Cocoa

class ImageCreator {
    var background: NSImage
    var subject: NSImage
    
    init(background: NSImage, subject: NSImage) {
        self.background = background
        self.subject = subject
    }
    
    func createImage() -> NSImage {
        return NSImage.fromCIImage(subject.ciImage()!.composited(over: background.ciImage()!))
    }
    
    func move() {
        
    }
    
    func changeSize() {
        
    }
    
    func rotate() {
        
    }
}

extension NSImage {
    /// Generates a CIImage for this NSImage.
    /// - Returns: A CIImage optional.
    func ciImage() -> CIImage? {
        guard let data = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return nil
        }
        let ci = CIImage(bitmapImageRep: bitmap)
        return ci
    }
    
    /// Generates an NSImage from a CIImage.
    /// - Parameter ciImage: The CIImage
    /// - Returns: An NSImage optional.
    static func fromCIImage(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
}
