//
//  MLCollageTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/24/24.
//

import XCTest
import SnapshotTesting
@testable import MLCollage
import SwiftUI

final class MLCollageTests: XCTestCase {
    
    func testJSON() throws {
        let sut = Annotations(annotations: [.init(label: "test foo label")], image: "test image string")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
        let output = try encoder.encode([sut])
        
        let stringPrint = String.init(data: output, encoding: .utf8)!
        
        assertSnapshot(of: stringPrint, as: .dump)
    }
    
//    func testSnapshot() {
//        let string = "Test String fail"
//        let photo = ""
//        var sut = Subject(label: "test label", image: CII, coordinates: <#T##Subject.Coordinates#>)
//
//        assertSnapshot(of: string, as: .dump, record: true)
//    }
    
}
