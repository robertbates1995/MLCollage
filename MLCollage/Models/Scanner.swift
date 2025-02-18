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

        let pixelIndex = (height - y - 1) * width + x * 4

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

    func horizontalVisible(image: CGImage, y: Int) -> Bool {
        for x in 0..<image.width {
            if !isPointInvisible(x: x, y: y, in: image) {
                return true
            }
        }
        return false
    }
    
    func findSubjectSize(image: UIImage) -> CGRect {
        guard let cgImage = image.toCGImage().cgImage,
            cgImage.colorSpace?.model == .rgb,
            cgImage.bitsPerPixel == 32,
            cgImage.bitsPerComponent == 8
        else { return CGRect(origin: CGPoint(x: 0, y: 0), size: image.size) }
        
        let canvasWidth = cgImage.width
        let canvasHeight = cgImage.height
        
        var leftHit = false
        var left = 0
        var right = 0
        var top = 0
        var bottom = canvasHeight
        
        for x in 0 ..< canvasWidth {
            for y in 0 ..< canvasHeight {
                //this scan will go from left to right, bottom to top.
                if !isPointInvisible(x: x, y: y, in: cgImage) {
                    //left value is first point seen
                    if !leftHit {
                        left = x
                        leftHit = true
                    }
                    //bottom value is lowest seen height value
                    if bottom > y {
                        bottom = y
                    }
                    //top value is highest seen height value
                    if top <= x {
                        top = x + 1
                    }
                    //right value is last point seen
                    if right <= y {
                        right = y + 1
                    }
                }
            }
        }
        
        let size = CGSize(
            width: (top - bottom),
            height: (right - left))
        
        return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
    }
}
