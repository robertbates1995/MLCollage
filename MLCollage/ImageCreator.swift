//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
import Cocoa

@Observable
class ImageCreator {
    var background: CIImage
    var subject: CIImage
    
    init(background: NSImage, subject: NSImage) {
        self.background = background.ciImage()!
        self.subject = subject.ciImage()!
    }
    
    func createImage() -> NSImage {
        return NSImage.fromCIImage(subject.composited(over: background))
    }
    
    func translate() {
        subject = subject.transformed(by: .init(translationX: 10, y: 10))
    }
    
    func scale() {
        
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
