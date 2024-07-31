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
        //will likely need parameters to control subject orientation
        //create one annotation and one Collage in this step
        let foo = UIImage(ciImage:subject.composited(over: background)) 
        return .init(image: foo, data: CollageData(annotations: [], image: "image"))
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
