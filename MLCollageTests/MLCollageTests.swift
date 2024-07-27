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
    
    func testJSON() {
        
    }
    
    func testSnapshot() {
        let string = "Test String fail"
        let photo = ""
       // var sut = Subject(label: "test label", image: CII, coordinates: <#T##Subject.Coordinates#>)

        assertSnapshot(of: string, as: .dump, record: true)
    }
    
    func assertSnapshot<Value, Format>(
      of value: @autoclosure () throws -> Value,
      as snapshotting: Snapshotting<Value, Format>,
      named name: String? = nil,
      record recording: Bool? = nil,
      timeout: TimeInterval = 5,
      fileID: StaticString = #fileID,
      file filePath: StaticString = #filePath,
      testName: String = #function,
      line: UInt = #line,
      column: UInt = #column
    ) {
      let failure = verifySnapshot(
        of: try value(),
        as: snapshotting,
        named: name,
        record: recording,
        snapshotDirectory: FileManager.default.temporaryDirectory.appending(path: "_snapshot").path(),
        timeout: timeout,
        fileID: fileID,
        file: filePath,
        testName: testName,
        line: line,
        column: column
      )
      guard let message = failure else { return }
        XCTFail(message, file: filePath, line: line)
    }
}
