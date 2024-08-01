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
    
    func translateBy(_ value: CGFloat) {
        _image = _image.transformed(by: .init(translationX: value, y: value))
    }
    
    func scale() {
        
    }
    
    func rotate() {
        
    }
}
