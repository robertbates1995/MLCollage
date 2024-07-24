//
//  MLCollageTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/24/24.
//

import XCTest
import SnapshotTesting

final class MLCollageTests: XCTestCase {
    
    func testSnapshot() {
        let string = "Test String"
        
        assertSnapshot(of: string, as: .dump)
    }
    
}
