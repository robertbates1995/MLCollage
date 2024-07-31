//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
import UIKit

@Observable
class CollageCreator {
    var background: UIImage { UIImage(ciImage:_background)}
    var _background: CIImage
    var subject: UIImage { UIImage(ciImage:_subject)}
    var _subject: CIImage
    
    init(background: UIImage, subject: UIImage) {
        self._background = background.ciImage!
        self._subject = subject.ciImage!
    }
    
    func createImage() -> UIImage {
        //create one annotation and one Collage in this step
        return UIImage(ciImage:_subject.composited(over: _background))
    }
    
    func createImageSet(population: Int) -> [UIImage] {
        var images = [UIImage]()
        var count = population
        while count > 0 {
            //translate()
            images.append(createImage())
            count -= 1
        }
        return images
    }
}
