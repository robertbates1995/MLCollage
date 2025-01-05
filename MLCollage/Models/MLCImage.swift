//
//  MLCImage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/2/24.
//

import UIKit

struct MLCImage: Identifiable, Hashable, Equatable {
    var id: String = UUID().uuidString
    var uiImage: UIImage
}

extension MLCImage {
    init(uiImage: UIImage) {
        id = UUID().uuidString
        self.uiImage = uiImage
    }
}
