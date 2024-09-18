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
    let subject1 = Subject(image: CIImage(image: .redApple1)!, label: "redApple")
    let subject2 = Subject(image: CIImage(image: .redApple2)!, label: "redApple")
    let subject3 = Subject(image: CIImage(image: .redApple3)!, label: "redApple")
    let subject4 = Subject(image: CIImage(image: .redApple4)!, label: "redApple")
    let subject5 = Subject(image: CIImage(image: .redApple5)!, label: "redApple")
    let subject6 = Subject(image: CIImage(image: .redApple6)!, label: "redApple")
    let subject7 = Subject(image: CIImage(image: .redApple7)!, label: "redApple")
    let subject8 = Subject(image: CIImage(image: .redApple8)!, label: "redApple")
    let subject9 = Subject(image: CIImage(image: .redApple9)!, label: "redApple")
    let subject10 = Subject(image: CIImage(image: .redApple10)!, label: "redApple")
    let subject11 = Subject(image: CIImage(image: .redApple11)!, label: "redApple")
    let subject12 = Subject(image: CIImage(image: .redApple12)!, label: "redApple")
    let subject13 = Subject(image: CIImage(image: .redApple13)!, label: "redApple")
    let subject14 = Subject(image: CIImage(image: .redApple14)!, label: "redApple")
    let subject15 = Subject(image: CIImage(image: .redApple15)!, label: "redApple")
    let subject16 = Subject(image: CIImage(image: .redApple16)!, label: "redApple")
    let subject17 = Subject(image: CIImage(image: .redApple17)!, label: "redApple")
    
    let background1 = CIImage(image: .forest)!
    let background2 = CIImage(image: .grid)!
    let background3 = CIImage(image: .blackGrid)!
    let background4 = CIImage(image: .crazyBackground1)!
    let background5 = CIImage(image: .crazyBackground2)!
    let background6 = CIImage(image: .crazyBackground3)!



    
    lazy var sut = Project(subjects: [subject3, 
                                      subject4,
                                      subject5,
                                      subject6,
                                      subject7,
                                      subject8,
                                      subject9,
                                      subject10,
                                      subject11,
                                      subject12,
                                      subject13,
                                      subject14,
                                      subject15,
                                      subject16,
                                      subject17
                                     ], backgrounds: [background1, background2, background3, background4, background5, background6], title: "test")
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
        sut.settings.population = 10
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
