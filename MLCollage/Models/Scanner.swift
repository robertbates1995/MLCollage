//
//  Scanner.swift
//  MLCollage
//
//  Created by Robert Bates on 1/31/25.
//

import UIKit

struct Scanner {
    func isPointInvisible(x: Int, y: Int, in image: CGImage) -> Bool {
        guard let pixelData = image.dataProvider?.data else { return false }

        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let width = image.bytesPerRow
        let height = image.height

        guard x >= 0, x < width, y >= 0, y < height else {
            return false
        }

        let pixelIndex = y * width + x * 4

        let alpha = data[pixelIndex + 3]
        return alpha == 0
    }

    func verticalSlice(image: CGImage, x: Int) -> Bool {
        for y in 0..<image.height {
            if !isPointInvisible(x: x, y: y, in: image) {
                return true
            }
        }
        return false
    }

    func horizontalSlice(image: CGImage, y: Int) -> Bool {
        for x in 0..<image.width {
            if !isPointInvisible(x: x, y: y, in: image) {
                return true
            }
        }
        return false
    }

    func findSubjectSize(image: UIImage) -> CGRect {
        guard let cgImage = image.cgImage,
            cgImage.colorSpace?.model == .rgb,
            cgImage.bitsPerPixel == 32,
            cgImage.bitsPerComponent == 8
        else { return CGRect(origin: CGPoint(x: 0, y: 0), size: image.size) }

        let canvasWidth = cgImage.width
        let canvasHeight = cgImage.height
        var subjectNotSeen = true
        var left = 0
        var right = 0
        var top = 0
        var bottom = 0
        //find subject width
        //iterate over all x values
        for x in 0...canvasWidth {
            //find if subject in vertical slice
            if verticalSlice(image: cgImage, x: x) {
                if subjectNotSeen {
                    left = x
                    subjectNotSeen = false
                } else {
                    right = x
                }
            }
        }
        subjectNotSeen = true
        //find subject height
        for y in 0..<canvasHeight {
            //find if subject in vertical slice
            if horizontalSlice(image: cgImage, y: y) {
                if subjectNotSeen {
                    top = y
                    subjectNotSeen = false
                } else {
                    bottom = y
                }
            }
        }
        let size = CGSize(
            width: (1 + right - left),
            height: (1 + bottom - top))
        
        return CGRect(origin: CGPoint(x: left, y: top), size: size)
        
    }
}
