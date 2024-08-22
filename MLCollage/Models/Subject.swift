//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 8/19/24.
//

import Foundation
import UIKit
import Accelerate

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
        temp.image = temp.image.transformed(by: .init(scaleX: mod.scale, y: mod.scale))
        temp.image = temp.image.
        return temp
    }
}

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
}

public extension CGImage
{
    public func horizontallyFlipped() -> CGImage?
    {
        return self.rotated(radians: 0.0, flipOverHorizontalAxis: true, flipOverVerticalAxis: false)
    }

    public func verticallyFlipped() -> CGImage?
    {
        return self.rotated(radians: 0.0, flipOverHorizontalAxis: false, flipOverVerticalAxis: true)
    }

    public func rotated(radians: CGFloat) -> CGImage?
    {
        return self.rotated(radians: radians, flipOverHorizontalAxis: false, flipOverVerticalAxis: false)
    }

    public func rotated(degrees: CGFloat) -> CGImage?
    {
        return self.rotated(radians: degreesToRadians(degrees), flipOverHorizontalAxis: false, flipOverVerticalAxis: false)
    }

    public func rotated(degrees: CGFloat, flipOverHorizontalAxis: Bool, flipOverVerticalAxis: Bool) -> CGImage?
    {
        return self.rotated(radians: degreesToRadians(degrees), flipOverHorizontalAxis: flipOverHorizontalAxis, flipOverVerticalAxis: flipOverVerticalAxis)
    }

    public func rotated(radians: CGFloat, flipOverHorizontalAxis: Bool, flipOverVerticalAxis: Bool) -> CGImage?
    {
        // Create an ARGB bitmap context
        let width = self.width
        let height = self.height

        let rotatedRect = CGRect(0, 0, width, height).applying(CGAffineTransform(rotationAngle: radians))

        guard let bmContext = CGContext.ARGBBitmapContext(width: Int(rotatedRect.size.width), height: Int(rotatedRect.size.height), withAlpha: true) else
        {
            return nil
        }

        // Image quality
        bmContext.setShouldAntialias(true)
        bmContext.setAllowsAntialiasing(true)
        bmContext.interpolationQuality = .high

        // Rotation happen here (around the center)
        bmContext.scaleBy(x: +(rotatedRect.size.width / 2.0), y: +(rotatedRect.size.height / 2.0))
        bmContext.rotate(by: radians)

        // Do flips
        bmContext.scaleBy(x: (flipOverHorizontalAxis ? -1.0 : 1.0), y: (flipOverVerticalAxis ? -1.0 : 1.0))

        // Draw the image in the bitmap context
        bmContext.draw(self, in: CGRect(-(CGFloat(width) / 2.0), -(CGFloat(height) / 2.0), CGFloat(width), CGFloat(height)))

        // Create an image object from the context
        return bmContext.makeImage()
    }

    public func pixelsRotated(degrees: Float) -> CGImage?
    {
        return self.pixelsRotated(radians: degreesToRadians(degrees))
    }

    public func pixelsRotated(radians: Float) -> CGImage?
    {
        // Create an ARGB bitmap context
        let width = self.width
        let height = self.height
        let bytesPerRow = width * numberOfComponentsPerARBGPixel
        guard let bmContext = CGContext.ARGBBitmapContext(width: width, height: height, withAlpha: true) else
        {
            return nil
        }

        // Draw the image in the bitmap context
        bmContext.draw(self, in: CGRect(0, 0, width, height))

        // Grab the image raw data
        guard let data = bmContext.data else
        {
            return nil
        }

        var src = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        var dst = vImage_Buffer(data: data, height: vImagePixelCount(height), width: vImagePixelCount(width), rowBytes: bytesPerRow)
        let bgColor: [UInt8] = [0, 0, 0, 0]
        vImageRotate_ARGB8888(&src, &dst, nil, radians, bgColor, vImage_Flags(kvImageBackgroundColorFill))

        return bmContext.makeImage()
    }

    public func reflected(height: Int = 0, fromAlpha: CGFloat = 1.0, toAlpha: CGFloat = 0.0) -> CGImage?
    {
        var h = height
        let width = self.width
        if h <= 0
        {
            h = self.height
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width, height), false, 0.0)
        guard let mainViewContentContext = UIGraphicsGetCurrentContext() else
        {
            return nil
        }

        guard let gradientMaskImage = CGImage.makeGrayGradient(width: 1, height: h, fromAlpha: fromAlpha, toAlpha: toAlpha) else
        {
            return nil
        }

        mainViewContentContext.clip(to: CGRect(0, 0, width, h), mask: gradientMaskImage)
        mainViewContentContext.draw(self, in: CGRect(0, 0, width, self.height))

        let theImage = mainViewContentContext.makeImage()

        UIGraphicsEndImageContext()

        return theImage
    }
    
    func degreesToRadians(_ degrees: CGFloat) -> CGFloat{
        return degrees * .pi / 180.0
    }
}
