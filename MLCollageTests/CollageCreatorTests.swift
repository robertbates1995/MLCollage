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
        
        assertSnapshot(of: collage.image, as: .image, record: false)
    }
    
    func testScaleToBackground() {
        let collage = makeCollage(subject: makeSubject(width: 300, height: 200))
        
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
        
        assertSnapshot(of: collage.image, as: .image, record: true)
        
        let collage2 = makeCollage(mod: Modification(translateX: 0.5, translateY: 0.5, scale: 0.5))
        
        assertSnapshot(of: collage2.image, as: .image, record: true)
        
        let collage3 = makeCollage(mod: Modification(translateX: 1, translateY: 1, scale: 0.5))
        
        assertSnapshot(of: collage3.image, as: .image, record: true)
        
        let collage4 = makeCollage(mod: Modification(translateX: 0.0, translateY: 0.0, scale: 0.5))
        
        assertSnapshot(of: collage4.image, as: .image, record: true)
    }
    
    func testTranslateMax() {
        let collage = makeCollage(mod: Modification(translateX: Modification.translateMax, translateY: 0.5), subject: makeSubject(width: 200, height: 50))
        
        assertSnapshot(of: collage.image, as: .image, record: true)
    }
}
