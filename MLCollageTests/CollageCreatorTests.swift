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
    lazy var sut = Project(subjects: [subject], backgrounds: [background], title: "ProjectTitle")
    let recording = false
    
    func testSubject() {
        let mod = Modification(translateX: 0.5, rotate: .pi)
        let result = subject.modify(mod, size: .init(width: 200, height: 200))
        assertSnapshot(of: UIImage(ciImage: result.image).toCGImage(), as: .image, record: recording)
    }
    
    func testCreateCollageSetNoMods() {
        //create a set of collage images
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 1)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testCreateCollageSetTranslate() {
        //create a set of collage images
        sut.translate = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 4)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testCreateCollageSetScale() {
        //create a set of collage images
        sut.scale = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 2)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testCreateCollageSetRotate() {
        //create a set of collage images
        sut.rotate = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 2)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testCreateCollageSetFlip() {
        //create a set of collage images
        sut.flip = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 4)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testFlipAndRotate() {
        sut.flip = true
        sut.rotate = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 8)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testFlipAndTranslate() {
        sut.translate = true
        sut.flip = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 16)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording)
            assertSnapshot(of: i.data, as: .dump, record: recording)
        }
    }
    
    func testApplyAllMods() {
        sut.scale = true
        sut.translate = true
        sut.rotate = true
        sut.flip = true
        let result = sut.createCollageSet()
        XCTAssertEqual(result.count, 64) //will need to be set to a different value based on number of results
        for i in result { assertSnapshot(of: i.image.toCGImage(), as: .image, record: recording) }
        assertSnapshot(of: try sut.createJSON(), as: .lines, record: recording)
    }
    
    func testExport() throws {
        sut.scale = true
        sut.translate = true
        sut.rotate = true
        sut.flip = true
        var url = FileManager.default.temporaryDirectory.appendingPathComponent(name, conformingTo: .directory)
        //delete the directory that is being tested (FileManager.shared.rm)
        try? FileManager.default.removeItem(at: url)
        //create a blank directory at the same spot
        XCTAssertNoThrow(try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false))
        sut.export(to: url)
        //use FileManager to make sure all files are present
        //xctassert the files exist, not necessaraly that they are correct
        try XCTAssertEqual(FileManager.default.contentsOfDirectory(atPath: url.path).count, 65)
    }
}

//delete directory at speciffic address
//create directory at speciffic address
//write files (json and all png) to directory
