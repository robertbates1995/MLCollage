//
//  CollageTests.swift
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

final class CollageTests: XCTestCase {
    let subject1 = Subject(image: CIImage(image: .compass)!, label: "compass")
    let subject2 = Subject(image: CIImage(image: .monke)!, label: "monkey")
    let subject3 = Subject(image: CIImage(image: .redApple1)!, label: "redApple1")
    let background1 = CIImage(image: .forest)!
    let background2 = CIImage(image: .grid)!
    
    lazy var sut = Project(subjects: [subject1, subject2, subject3], backgrounds: [background1, background2], title: "test")
    let recording = false //change to toggle global recording of test results
    
    func testJSON() throws {
        let result = try sut.createJSON()
        assertSnapshot(of: result, as: .lines)
    }
    
    func testSubject() {
        let mod = Modification(translateX: 0.5, rotate: .pi)
        let result = subject1.modify(mod: mod, backgroundSize: .init(width: 200, height: 200))
        assertSnapshot(of: UIImage(ciImage: result.image).toCGImage(), as: .image, record: recording)
    }
        
    func testCollageTranslate() {
        let mod = Modification(translateX: 0.5, translateY: 0.5)
        let subject = subject1.modify(mod: mod, backgroundSize: background1.extent.size)
        let result = Collage.create(subject: subject, background: background1, title: "CollageTitle")
        assertSnapshot(of: result.image.toCGImage(), as: .image, record: recording)
        assertSnapshot(of: result.annotations, as: .dump, record: recording)
    }
    
    func testExport() throws {
        sut.settings.population = 100
        var url = FileManager.default.temporaryDirectory.appendingPathComponent(name, conformingTo: .directory)
        print(url.path)
        //delete the directory that is being tested (FileManager.shared.rm)
        try? FileManager.default.removeItem(at: url)
        //create a blank directory at the same spot
        XCTAssertNoThrow(try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false))
        sut.export(to: url)
        //use FileManager to make sure all files are present
        //xctassert the files exist, not necessaraly that they are correct
        try XCTAssertEqual(FileManager.default.contentsOfDirectory(atPath: url.path).count, 21)
    }
    
    func testSaveLoad() throws {
        //saving part
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(name, conformingTo: .directory)
        try? FileManager.default.removeItem(at: url)
        XCTAssertNoThrow(try FileManager.default.createDirectory(at: url, withIntermediateDirectories: false))
        //give sut at least 2 subjects
        sut.subjects.append(contentsOf: [subject1, subject1, subject2])
        sut.settings.numberOfEachSubject = 3
        //call save at url
        sut.save(to: url)
        //create list of file names at url
        let result = try FileManager.default.contentsOfDirectory(atPath: url.path)
        //test list of names
        XCTAssertEqual(result.sorted(), ["backgrounds", "subjects", "test.sett"])
        try XCTAssertEqual(FileManager.default.contentsOfDirectory(atPath: url.appending(path: "subjects/compass").path).count, 3)
        try XCTAssertEqual(FileManager.default.contentsOfDirectory(atPath: url.appending(path: "subjects/monkey").path).count, 1)
        try XCTAssertEqual(FileManager.default.contentsOfDirectory(atPath: url.appending(path: "backgrounds").path).count, 1)
        
        //loading part
        let loaded = try Project(url: url.appending(path: "test.sett"))
        XCTAssertEqual(loaded.subjects.map(\.label).sorted(), sut.subjects.map(\.label).sorted())
        XCTAssertEqual(loaded.backgrounds.count, sut.backgrounds.count)
        XCTAssertEqual(loaded.settings, sut.settings)
        XCTAssertEqual(loaded.title, sut.title)
    }
}
