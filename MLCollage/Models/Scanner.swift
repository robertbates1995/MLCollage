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
    
    
    
    func newFindSubjectSize(image: UIImage) -> CGRect {
        guard let cgImage = image.toCGImage().cgImage,
            cgImage.colorSpace?.model == .rgb,
            cgImage.bitsPerPixel == 32,
            cgImage.bitsPerComponent == 8
        else { return CGRect(origin: CGPoint(x: 0, y: 0), size: image.size) }
        
        let canvasWidth = cgImage.width
        let canvasHeight = cgImage.height
        
        var leftHit = false
        var bottomHit = false

        var left = 0
        var right = 0
        var top = 0
        var bottom = 0
        
        for x in 0 ..< canvasWidth {
            for y in 0 ..< canvasHeight {
                //this scan will go from left to right, bottom to top.
                if !isPointInvisible(x: x, y: y, in: cgImage) {
                    //left value is first point seen
                    if !leftHit {
                        left = x - 1
                        leftHit = true
                    }
                    //bottom value is lowest seen height value
                    if !bottomHit {
                        bottom = y - 1
                        bottomHit = true
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
            width: (right - left),
            height: (top - bottom))
        
        return CGRect(origin: CGPoint(x: left, y: bottom), size: size)
    }
    
    
    
    func findSubjectSize(image: UIImage) -> CGRect {
        guard let cgImage = image.toCGImage().cgImage,
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
        for x in 0..<canvasWidth {
            //find if subject in vertical slice
            if verticalSlice(image: cgImage, x: x) {
                if subjectNotSeen {
                    left = x
                    subjectNotSeen = false
                } else {
                    right = x + 1
                }
            }
        }
        subjectNotSeen = true
        //find subject height
        for y in 0..<canvasHeight {
            //find if subject in vertical slice
            if horizontalVisible(image: cgImage, y: y) {
                if subjectNotSeen {
                    top = y
                    subjectNotSeen = false
                } else {
                    bottom = y + 1
                }
            }
        }
        let size = CGSize(
            width: (right - left),
            height: (bottom - top))
        
        return CGRect(origin: CGPoint(x: left, y: top), size: size)
    }
}
