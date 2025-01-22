//
//  CollageTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/31/24.
//

import CoreImage.CIFilterBuiltins
import CustomDump
import Foundation
import SnapshotTesting
import UIKit
import XCTest

@testable import MLCollage
import SwiftUICore

@MainActor
final class CollageTests: XCTestCase {
    let background = {
        var checkerBoardGenerator = CIFilter.checkerboardGenerator()
        checkerBoardGenerator.setDefaults()
        checkerBoardGenerator.center = CGPoint(x: 0, y: 0)
        checkerBoardGenerator.color0 = .gray
        checkerBoardGenerator.color1 = .black
        checkerBoardGenerator.width = 50
        checkerBoardGenerator.sharpness = 1
        return checkerBoardGenerator.outputImage!.cropped(
            to: CGRect(x: 0.0, y: 0.0, width: 200, height: 100)
        ).toUIImage()
    }()
    
    func makeSubject(width: Double, height: Double) -> UIImage {
        let bounds = CGRect(
            origin: .zero, size: CGSize(width: width, height: height))
        var image = CIImage(color: .white).cropped(to: bounds)

        let spotBounds = CGRect(
            origin: .zero, size: CGSize(width: width / 2, height: height / 2))
        let blue = CIImage(color: .blue).cropped(to: spotBounds)
        image = blue.composited(over: image)

        let red = CIImage(color: .red).cropped(
            to: spotBounds.offsetBy(dx: 0, dy: height / 2))
        image = red.composited(over: image)

        return image.cropped(to: bounds).toUIImage()
    }
    
    
    func makeCollage(mod: Modification? = nil, subject: UIImage? = nil) -> Collage {
        let sut = CollageBlueprint(
            mod: mod ?? Modification(),
            subjectImage: subject ?? makeSubject(width: 100, height: 100),
            background: background,
            label: "testLabel",
            fileName: "testFileName")
        return sut.create()
    }
    
    func testCollageBlueprint() {
        let collage = makeCollage()
        
        XCTAssertEqual(collage.json.annotation[0].coordinates, .init(x: 50, y: 50, width: 100, height: 100))
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleToBackground() {
        let collage = makeCollage(subject: makeSubject(width: 300, height: 200))
        
        XCTAssertEqual(collage.json.annotation[0].coordinates, .init(x: 75, y: 50, width: 150, height: 100))
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleMin() {
        let collage = makeCollage(mod: Modification(scale: Modification.scaleMin))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleMax() {
        let collage = makeCollage(mod: Modification(scale: Modification.scaleMax))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testFlip() {
        let collage = makeCollage(mod: Modification(flipX: true, flipY: true))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testRotate() {
        let collage = makeCollage(mod: Modification(rotate: Modification.rotateMax/4))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    
    func testTranslate() {
        let collage = makeCollage(mod: Modification(translateX: 0.5, translateY: 0.5), subject: makeSubject(width: 200, height: 50))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
        
        let collage2 = makeCollage(mod: Modification(translateX: 0.5, translateY: 0.5, scale: 0.5))
        
        assertSnapshot(of: collage2.image, as: .image, record: false)
        
        let collage3 = makeCollage(mod: Modification(translateX: 1, translateY: 1, scale: 0.5))
        
        assertSnapshot(of: collage3.image, as: .image, record: false)
        
        let collage4 = makeCollage(mod: Modification(translateX: 0.0, translateY: 0.0, scale: 0.5))
        
        assertSnapshot(of: collage4.image, as: .image, record: false)
    }
    
    func testTranslateMax() {
        let collage = makeCollage(mod: Modification(translateX: Modification.translateMax, translateY: 0.5), subject: makeSubject(width: 200, height: 50))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleSubjectImage() {
        let sut = CollageBlueprint(
            mod: Modification(scale: 0.5),
            subjectImage: makeSubject(width: 100, height: 100),
            background: background,
            label: "testLabel",
            fileName: "testFileName")
        let collage = sut.create(size: 50.0)
        
        XCTAssertEqual(collage.json.annotation[0].coordinates, .init(x: 12.5, y: 37.5, width: 25, height: 25))
        XCTAssertEqual(collage.image.size, CGSize(width: 50, height: 50))
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    /// -------
    
    func createTestImage(canvasSize: CGSize, shapeSize: CGSize) -> UIImage? {
        //create canvas
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw a red circle
        let center = CGPoint(x: canvasSize.width/2, y: canvasSize.height/2)
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: CGRect(origin: center, size: shapeSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func isPointInvisible(point: CGPoint, in image: UIImage) -> Bool {
            guard let cgImage = image.cgImage else { return false }
            
            let pixelData = cgImage.dataProvider?.data
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
            
            let width = cgImage.width
            let height = cgImage.height
            
            guard point.x >= 0, point.x < CGFloat(width), point.y >= 0, point.y < CGFloat(height) else {
                return false
            }
            
            let pixelIndex = ((Int(point.y) * width) + Int(point.x)) * 4
            
            let alpha = data[pixelIndex + 3]
            return alpha == 0
    }
    
    func findSubjectSize(image: UIImage) -> CGSize {
        let canvasWidth = image.size.width
        let canvasHeight = image.size.height
        var subjectNotSeen = true
        var subjectStartWidth: CGFloat = 0.0
        var subjectEndWidth: CGFloat = 0.0
        var subjectStartHeight: CGFloat = 0.0
        var subjectEndHeight: CGFloat = 0.0
        //find subject width
        for y in stride(from: 0.0, to: canvasWidth, by: 1.0) {
            for x in stride(from: 0.0, to: canvasHeight, by: 1.0) {
                if !isPointInvisible(point: CGPoint(x: x, y: y), in: image) {
                    if subjectNotSeen {
                        subjectStartWidth = y
                        subjectNotSeen = false
                    } else {
                        subjectEndWidth = x
                    }
                }
            }
        }
        subjectNotSeen = true
        //find subject height
        for x in stride(from: 0.0, to: canvasHeight, by: 1.0) {
            for y in stride(from: 0.0, to: canvasWidth, by: 1.0) {
                if !isPointInvisible(point: CGPoint(x: x, y: y), in: image) {
                    if !subjectNotSeen {
                        subjectStartHeight = x
                        subjectNotSeen = false
                    }
                    subjectEndHeight = x
                }
            }
        }
        return CGSize(width: (subjectEndWidth  - subjectStartWidth),
                      height:  (subjectEndHeight - subjectStartHeight))
    }
    
    func testTestImage() {
        let shape = CGSize(width: 2.0, height: 2.0)
        let canvas = CGSize(width: 10, height: 10)
        let sut = createTestImage(canvasSize: canvas, shapeSize: shape)
        assertSnapshot(of: sut!, as: .image, record: false)
    }
    
    func testFindSubjectSize() {
        let expected = CGSize(width: 2.0, height: 2.0)
        let canvas = CGSize(width: 10, height: 10)
        guard let testImage = createTestImage(canvasSize: canvas, shapeSize: expected) else { return }
        let actual = findSubjectSize(image: testImage)
        XCTAssertEqual(actual, expected)
    }
}
