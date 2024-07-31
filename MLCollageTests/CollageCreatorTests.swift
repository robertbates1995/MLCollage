//
//  CollageCreatorTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import XCTest
import SnapshotTesting
@testable import MLCollage
import SwiftUI

final class CollageCreatorTests: XCTestCase {
    let sut = CollageCreator()
    
    func testCreateCollage() {
        //create a single collage image
        let result = sut.create(subject: CIImage(image: .monke)!, background: CIImage(image: .forest)!, title: "Test Collage", numberOfSubjects: 2)
        assertSnapshot(of: result.image, as: .image)
        assertSnapshot(of: result.data, as: .dump)
    }
    
    func testCreateCollageData() {#imageLiteral(resourceName: "testCreateCollage.1.png")
        //create associated data to a single image
    }
}
