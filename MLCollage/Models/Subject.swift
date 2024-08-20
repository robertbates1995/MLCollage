//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 8/19/24.
//

import Foundation
import UIKit

struct Subject {
    var image: CIImage
    var label: String
    init(image: CIImage = CIImage.black, label: String = "subject label") {
        self.image = image
        self.label = label
    }
    
    //modify must return copy of subject without changing OG
    func modify(_ mod: Modification, size: CGSize) -> Subject {
        var temp = self
        let extent = temp.image.extent
        temp.image = temp.image.transformed(by: .init(translationX: mod.translateX * (size.width - extent.width), y: mod.translateY * (size.height - extent.height)))
        temp.image = temp.image.transformed(by: .init(scaleX: mod.scaleChangeX, y: mod.scaleChangeY))
        return temp
    }
}
