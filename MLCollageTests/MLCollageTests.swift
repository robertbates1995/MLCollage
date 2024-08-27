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
    let sut = Project(
        subjects: [Subject(image: CIImage(image: .monke)!, label: "monke")],
        backgrounds: [CIImage(image: .forest)!],
        title: "collageTitle",
        translate: true,
        scale: true,
        rotate: true,
        flip: true
    )
    
    func testJSON() throws {
        let result = try sut.createJSON()
        assertSnapshot(of: result, as: .lines)
    }
}
