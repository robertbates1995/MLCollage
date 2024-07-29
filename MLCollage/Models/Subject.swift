//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 7/24/24.
//

import Foundation
import Cocoa

class Subject {
    var image: NSImage {.fromCIImage(_image)}
    private var _image: CIImage
    
    init(_image: CIImage) {
        self._image = _image
    }
    
    func translate() {
        _image = _image.transformed(by: .init(translationX: 10, y: 10))
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
