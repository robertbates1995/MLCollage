//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
import UIKit
import SwiftUI

@Observable
class CollageCreator {
    func create(subject: CIImage, background: CIImage) -> Collage {
        //create one annotation and one Collage in this step
        return UIImage(ciImage:subject.composited(over: background))
    }
}

class Collage {
    var image: UIImage
    var data: CollageData
    
    init(image: UIImage, data: CollageData) {
        self.image = image
        self.data = data
    }
}
