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

    func testRotate() {
        let collage = makeCollage(
            mod: Modification(rotate: Modification.rotateMax / 4))

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

    /// -------

    func createTestImage(canvasSize: CGSize, shapeSize: CGSize) -> UIImage? {
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
        print(alpha)
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

    func findSubjectSize(image: UIImage) -> CGSize {
        guard let cgImage = image.cgImage,
            cgImage.colorSpace?.model == .rgb,
            cgImage.bitsPerPixel == 32,
            cgImage.bitsPerComponent == 8
        else { return image.size }

        let canvasWidth = cgImage.width
        let canvasHeight = cgImage.height
        var subjectNotSeen = true
        var subjectStartWidth = 0
        var subjectEndWidth = 0
        var subjectStartHeight = 0
        var subjectEndHeight = 0
        //find subject width
        //iterate over all x values
        for x in 0...canvasWidth {
            //find if subject in vertical slice
            if verticalSlice(image: cgImage, x: x) {
                if subjectNotSeen {
                    subjectStartWidth = x
                    subjectNotSeen = false
                } else {
                    subjectEndWidth = x
                }
            }
        }
        subjectNotSeen = true
        //find subject height

        return CGSize(
            width: (subjectEndWidth - subjectStartWidth),
            height: (subjectEndHeight - subjectStartHeight))
    }

    func testFindSubjectSize() {
        let expected = CGSize(width: 5.0, height: 5.0)
        let canvas = CGSize(width: 10, height: 10)
        guard
            let testImage = createTestImage(
                canvasSize: canvas, shapeSize: expected)
        else { return }
        let actual = findSubjectSize(image: testImage)
        XCTAssertEqual(actual, expected)
    }

    func testSlice() {
        let expected = CGSize(width: 1.0, height: 1.0)
        let canvas = CGSize(width: 10, height: 10)
        guard
            let testImage = createTestImage(
                canvasSize: canvas, shapeSize: expected),
            let cgImage = testImage.cgImage
        else { return }
        let hit = verticalSlice(image: cgImage, x: 5)
        let miss = verticalSlice(image: cgImage, x: 1)
        XCTAssertEqual(hit, true)
        XCTAssertEqual(miss, false)
        assertSnapshot(of: testImage, as: .image, record: false)
    }

    func testTestImage() {
        let shape = CGSize(width: 5.0, height: 5.0)
        let canvas = CGSize(width: 10, height: 10)
        guard let sut = createTestImage(canvasSize: canvas, shapeSize: shape)
        else { return }
        assertSnapshot(of: sut, as: .image, record: false)
    }
}
