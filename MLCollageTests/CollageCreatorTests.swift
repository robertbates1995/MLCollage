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
    let sut = CollageSetCreator(subject: CIImage(image: .monke)!, subjectLabel: "monke", background: CIImage(image: .forest)!, title: "Test CollageSet", numberOfSubjects: 1)
    
    func testCreateCollageSingleSubject() {
        //create a single collage image
        let result = sut.creator.create(subjects: [(CIImage(image: .monke)!, "monke")], background: CIImage(image: .forest)!, title: "Test Title")
        assertSnapshot(of: result.image.toCGImage(), as: .image)
        expectNoDifference(result.data, .init(annotations: [.init(label: "monke", coordinates: .init(x: 62.5, y: 62.5, width: 125.0, height: 125.0))], title: "Test Title"))
        //assertSnapshot(of: result.data, as: .dump)
    }
    
    func testCreateCollageSetXTranslate() {
        //create a set of collage images
        let result = sut.createCollageSet(population: 3, translateX: 50, translateY: 0, scaleChangeX: 0, scaleChangeY: 0)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
    
    func testCreateCollageSetYTranslate() {
        //create a set of collage images
        let result = sut.createCollageSet(population: 3, translateX: 0, translateY: 5, scaleChangeX: 0, scaleChangeY: 0)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image)
            assertSnapshot(of: i.data, as: .dump)
        }
    }
    
    func testCreateCollageSetEnlarge() {
        let result = sut.createCollageSet(population: 3, translateX: 0, translateY: 0, scaleChangeX: 1.1, scaleChangeY: 1.1)
        for i in result {
            assertSnapshot(of: i.image.toCGImage(), as: .image, record: false)
            assertSnapshot(of: i.data, as: .dump, record: false)
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
