//
//  CollageCreatorTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import XCTest
import SnapshotTesting
import CustomDump
@testable import MLCollage
import SwiftUI

final class CollageCreatorTests: XCTestCase {
    let subject = Subject(image: CIImage(image: .monke)!, label: "monke")
    let background = CIImage(image: .forest)!
    lazy var sut = Project(subjects: [subject], backgrounds: [background])
    
    func testSubject() {
        let mod = Modification(translateX: 0.5, rotate: .pi)
        let result = subject.modify(mod, size: .init(width: 200, height: 200))
        assertSnapshot(of: UIImage(ciImage: result.image).toCGImage(), as: .image)
    }
    
    func testCreateCollageSetNoMods() {
        //create a set of collage images
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 1)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
    
    func testCreateCollageSetTranslate() {
        //create a set of collage images
        sut.translate = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 4)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
    
    func testCreateCollageSetScale() {
        //create a set of collage images
        sut.scale = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 2)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
    
    func testCreateCollageSetRotate() {
        //create a set of collage images
        sut.rotate = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 2)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
    
    func testApplyAllMods() {
        sut.scale = true
        sut.translate = true
        sut.rotate = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 16) //will need to be set to a different value based on number of results
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
}

