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
            //translate()
            images.append(createImage())
            count -= 1
        }
        return images
    }
}
