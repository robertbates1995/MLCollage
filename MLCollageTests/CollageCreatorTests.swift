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
import SwiftUICore
import UIKit
import XCTest

@testable import MLCollage

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
    
    func makeCollage(mod: Modification? = nil, subject: UIImage? = nil)
    -> Collage
    {
        let sut = CollageBlueprint(
            mod: mod ?? Modification(),
            subjectImage: subject ?? makeSubject(width: 100, height: 100),
            background: background,
            label: "testLabel",
            fileName: "testFileName")
        return sut.create()
    }
    
    func makeTestImage(canvasSize: CGSize, shapeSize: CGSize) -> UIImage? {
        //create canvas
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 1.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Draw a red circle
        let offset = canvasSize.width / 2 - shapeSize.width / 2
        let center = CGPoint(x: offset, y: offset)
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: CGRect(origin: center, size: shapeSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    //------------------------//
    //TODO: The following will need to be updated...
    //as well as checked to be accurate after
    //fixing rotation anchor point issue.
    func testRotate() {
        let collage = makeCollage(
            mod: Modification(rotate: 0)).image
        let collage1 = makeCollage(
            mod: Modification(rotate: 1)).image
        let collage2 = makeCollage(
            mod: Modification(rotate: 0)).image
        let collage3 = makeCollage(
            mod: Modification(rotate: 0.25)).image
        let collage4 = makeCollage(
            mod: Modification(rotate: 0.75)).image
        
        let collages = [collage, collage1, collage2, collage3, collage4]
        
        for collage in collages {
            assertSnapshot(of: collage, as: .image, record: false)
        }
        XCTAssertEqual(collage.pngData(), collage.pngData())
        XCTAssertEqual(collage.pngData(), collage1.pngData())
        XCTAssertEqual(collage.pngData(), collage2.pngData())
    }
    
    func testPreviewImage() {
        let collage = makeCollage()
        
        assertSnapshot(of: collage.previewImage, as: .image, record: false)
    }
        
    func testFlipAndTrim() {
        let width = 100.0
        let height = 100.0
        
        let bounds = CGRect(
            origin: .zero, size: CGSize(width: width, height: height))
        var image = CIImage(color: .clear).cropped(to: bounds)
        
        let spotBounds = CGRect(
            origin: .zero, size: CGSize(width: width / 2, height: height / 2))
        let blue = CIImage(color: .blue).cropped(to: spotBounds)
        image = blue.composited(over: image)
        
        let red = CIImage(color: .red).cropped(
            to:  CGRect(
                origin: .zero, size: CGSize(width: width / 4, height: height / 4)))
        image = red.composited(over: image)
        
        let blueprint = CollageBlueprint(mod: Modification(translateX: 0.5,
                                                           translateY: 0.5,
                                                           scale: 0.5,
                                                           flipY: true),
                                         subjectImage: image.toUIImage(),
                                         background: .crazyBackground1,
                                         label: "apple",
                                         fileName: "apple_.png")
        let collage = blueprint.create()
        
        assertSnapshot(of: collage.previewImage, as: .image, record: false)
    }
    
    func testRotateAndTrim() {
        let width = 100.0
        let height = 100.0
        
        let bounds = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        var image = CIImage(color: .clear).cropped(to: bounds)
        
        let spotBounds = CGRect(
            origin: .zero, size: CGSize(width: width / 2, height: height / 2))
        let blue = CIImage(color: .blue).cropped(to: spotBounds)
        image = blue.composited(over: image)
        
        let red = CIImage(color: .red).cropped(
            to:  CGRect(
                origin: .zero, size: CGSize(width: width / 4, height: height / 4)))
        image = red.composited(over: image)
        
        let blueprint = CollageBlueprint(mod: Modification(translateX: 0.5,
                                                           translateY: 0.5,
                                                           scale: 0.5,
                                                           rotate: 0.25),
                                         subjectImage: image.toUIImage(),
                                         background: .crazyBackground1,
                                         label: "apple",
                                         fileName: "apple_.png")
        let collage = blueprint.create()
        
        assertSnapshot(of: collage.previewImage, as: .image, record: false)
    }
    //------------------------//

    
    func testCollageBlueprint() {
        let collage = makeCollage()
        
        XCTAssertEqual(
            collage.json.annotation[0].coordinates,
            .init(x: 50, y: 50, width: 100, height: 100))
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleToBackground() {
        let collage = makeCollage(subject: makeSubject(width: 300, height: 200))
        
        XCTAssertEqual(
            collage.json.annotation[0].coordinates,
            .init(x: 75, y: 50, width: 150, height: 100))
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleMin() {
        let collage = makeCollage(
            mod: Modification(scale: Modification.scaleMin))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleMax() {
        let collage = makeCollage(
            mod: Modification(scale: Modification.scaleMax))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testFlip() {
        let collage = makeCollage(mod: Modification(flipX: true, flipY: true))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testTranslate() {
        let collage = makeCollage(
            mod: Modification(translateX: 0.5, translateY: 0.5),
            subject: makeSubject(width: 200, height: 50))
        
        assertSnapshot(of: collage.image, as: .image, record: false)
        
        let collage2 = makeCollage(
            mod: Modification(translateX: 0.5, translateY: 0.5, scale: 0.5))
        
        assertSnapshot(of: collage2.image, as: .image, record: false)
        
        let collage3 = makeCollage(
            mod: Modification(translateX: 1, translateY: 1, scale: 0.5))
        
        assertSnapshot(of: collage3.image, as: .image, record: false)
        
        let collage4 = makeCollage(
            mod: Modification(translateX: 0.0, translateY: 0.0, scale: 0.5))
        
        assertSnapshot(of: collage4.image, as: .image, record: false)
    }
    
    func testTranslateMax() {
        let collage = makeCollage(
            mod: Modification(
                translateX: Modification.translateMax, translateY: 0.5),
            subject: makeSubject(width: 200, height: 50))
        
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
        
        XCTAssertEqual(
            collage.json.annotation[0].coordinates,
            .init(x: 12.5, y: 37.5, width: 25, height: 25))
        XCTAssertEqual(collage.image.size, CGSize(width: 50, height: 50))
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testFindSubjectSize() {
        let sut = Scanner()
        let subjectSize = CGSize(width: 6.0, height: 6.0)
        let expectedSize = CGSize(width: 6.0, height: 6.0)
        let canvas = CGSize(width: 10, height: 10)
        let expected = CGRect(origin: .init(x: 2.0, y: 2.0), size: expectedSize)
        guard
            let testImage = makeTestImage(
                canvasSize: canvas, shapeSize: subjectSize)
        else { return }
        let actual = sut.findSubjectSize(image: testImage)
        XCTAssertEqual(actual, expected)
    }
    
    func testSlice() {
        let sut = Scanner()
        let expected = CGSize(width: 1.0, height: 1.0)
        let canvas = CGSize(width: 10, height: 10)
        guard
            let testImage = makeTestImage(
                canvasSize: canvas, shapeSize: expected),
            let cgImage = testImage.cgImage
        else { return }
        let hit = sut.verticalSlice(image: cgImage, x: 5)
        let miss = sut.verticalSlice(image: cgImage, x: 1)
        XCTAssertEqual(hit, true)
        XCTAssertEqual(miss, false)
        assertSnapshot(of: testImage, as: .image, record: false)
    }
    
    func testTestImage() {
        let shape = CGSize(width: 5.0, height: 5.0)
        let canvas = CGSize(width: 10, height: 10)
        guard let sut = makeTestImage(canvasSize: canvas, shapeSize: shape)
        else { return }
        assertSnapshot(of: sut, as: .image, record: false)
    }
}
