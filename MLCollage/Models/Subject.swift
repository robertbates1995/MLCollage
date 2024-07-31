//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 7/24/24.
//

import Foundation
import UIKit

class Subject {
    var image: UIImage {UIImage(ciImage: _image)}
    private var _image: CIImage
    
    init(_image: CIImage) {
        self._image = _image
    }
    
    func translate() {
        _image = _image.transformed(by: .init(translationX: 10, y: 10))
    }
    
    func scale() {
        
    }
    
    func rotate() {
        
    }
}
