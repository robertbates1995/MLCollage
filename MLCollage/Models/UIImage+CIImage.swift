//
//  UIImage+CIImage.swift
//  MLCollage
//
//  Created by Robert Bates on 10/4/24.
//

import UIKit

extension UIImage {
    func toCGImage() -> UIImage {
        guard let ciImage = self.ciImage else {
            return self
        }
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return self
    }
    
    func toCIImage() -> CIImage {
        if let temp = self.ciImage { return temp }
        return CIImage(cgImage: cgImage!)
    }
}

extension CIImage {
    func toUIImage() -> UIImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(self, from: extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
