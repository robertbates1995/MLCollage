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
    var background: NSImage { .fromCIImage(_background)}
    var _background: CIImage
    var subject: NSImage { .fromCIImage(_subject)}
    var _subject: CIImage
    
    init(background: NSImage, subject: NSImage) {
        self._background = background.ciImage()!
        self._subject = subject.ciImage()!
    }
    
    func createImage() -> NSImage {
        return NSImage.fromCIImage(_subject.composited(over: _background))
    }
    
    func createImageSet(population: Int) -> [NSImage] {
        var images = [NSImage]()
        var count = population
        while count > 0 {
            translate()
            images.append(createImage())
            count -= 1
        }
        return images
    }
    
    func translate() {
        _subject = _subject.transformed(by: .init(translationX: 10, y: 10))
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
