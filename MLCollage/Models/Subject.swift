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

//extension UIImage {
//    /// Generates a CIImage for this UIImage.
//    /// - Returns: A CIImage optional.
//    func ciImage() -> CIImage? {
//        guard let data = self.tiffRepresentation,
//              let bitmap = NSBitmapImageRep(data: data) else {
//            return nil
//        }
//        let ci = CIImage(bitmapImageRep: bitmap)
//        return ci
//    }
//    
//    /// Generates an UIImage from a CIImage.
//    /// - Parameter ciImage: The CIImage
//    /// - Returns: An UIImage optional.
//    static func fromCIImage(_ ciImage: CIImage) -> UIImage {
//        let rep = NSCIImageRep(ciImage: ciImage)
//        let UIImage = UIImage(size: rep.size)
//        UIImage.addRepresentation(rep)
//        return UIImage
//    }
//}
