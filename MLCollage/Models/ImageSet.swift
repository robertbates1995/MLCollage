//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

class ImageSet {
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
