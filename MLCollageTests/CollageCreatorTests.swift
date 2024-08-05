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
    let sut = CollageSetCreator(subject: CIImage(image: .monke)!, background: CIImage(image: .forest)!, title: "Test CollageSet", numberOfSubjects: 1)
    
    func testCreateCollage() {
        //create a single collage image
        let result = sut.creator.create(subjects: [(CIImage(image: .monke)!, "monke")], background: CIImage(image: .forest)!, title: "Test Title")
        assertSnapshot(of: result.image.toCGImage(), as: .image)
        XCTAssertNoDifference(result.data, .init(annotations: [.init(label: "monke")], title: "Test Title"))
        //assertSnapshot(of: result.data, as: .dump)
    }
    
    
    
    func testCreateCollageSet() {
        //create a set of collage images
        let result = sut.createCollageSet(population: 3, translateX: 5, translateY: 5)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
}

extension UIImage {
    func toCGImage() -> UIImage {
        guard let ciImage = self.ciImage else {
            return self
        }
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return self
    }
}
