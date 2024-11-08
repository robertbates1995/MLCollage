//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import UIKit

struct Subject {
    var label: String
    var images: [UIImage]
    
    init(label: String, images: [UIImage] = []) {
        self.label = label
        self.images = images
    }
}
