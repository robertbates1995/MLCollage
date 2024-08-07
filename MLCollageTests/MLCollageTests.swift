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
        let sut = CollageData(annotations: [.init(label: "test label")], title: "test title")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
        let output = try encoder.encode([sut])
        
        let stringPrint = String.init(data: output, encoding: .utf8)!
        
        assertSnapshot(of: stringPrint, as: .lines, record: false)
    }
}
