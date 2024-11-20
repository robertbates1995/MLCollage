//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import UIKit

struct Subject {
    var id: String
    var label: String
    var images: [UIImage]
}

extension Subject {
    init(label: String, images: [UIImage] = []) {
        id = UUID().uuidString
        self.label = label
        self.images = images
    }
}
