//
//  CollageTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import XCTest
import CustomDump
@testable import MLCollage
import SwiftUI

final class CollageTests: XCTestCase {
    let subject1 = Subject(image: CIImage(image: .apple1)!, label: "redApple")
    let subject2 = Subject(image: CIImage(image: .apple2)!, label: "redApple")
    let subject3 = Subject(image: CIImage(image: .apple3)!, label: "redApple")
    let subject4 = Subject(image: CIImage(image: .apple4)!, label: "redApple")
    let subject5 = Subject(image: CIImage(image: .apple5)!, label: "redApple")
    let subject6 = Subject(image: CIImage(image: .apple6)!, label: "redApple")
    let subject7 = Subject(image: CIImage(image: .apple7)!, label: "redApple")
    let subject8 = Subject(image: CIImage(image: .apple8)!, label: "redApple")
    let subject9 = Subject(image: CIImage(image: .redApple9)!, label: "redApple")
    let subject10 = Subject(image: CIImage(image: .redApple10)!, label: "redApple")
    
    
    let subject11 = Subject(image: CIImage(image: .apple1)!, label: "redApple")
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
    
    lazy var sut = Project(subjects: [subject1, subject2, subject3, subject4, subject5, subject6, subject7, subject8],
                           backgrounds: [background1, background2, background3, background4, background5, background6],
                           title: "test")
    let recording = false //change to toggle global recording of test results
    
    func testExport() throws {
        sut.settings.population = 50
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
}
