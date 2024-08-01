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
    let sut = CollageSetCreator(subject: CIImage(image: .monke)!, background: CIImage(image: .forest)!, title: "Test CollageSet", numberOfSubjects: 1)
    
    func testCreateCollage() {
        //create a single collage image
        let result = sut.creator.create(subject: CIImage(image: .monke)!, background: CIImage(image: .forest)!, title: "Test Collage", numberOfSubjects: 2)
        assertSnapshot(of: result.image.toCGImage(), as: .image)
        assertSnapshot(of: result.data, as: .dump)
    }
    
    func testCreateCollageSet() {
        //create a set of collage images
        let result = sut.createCollageSet(population: 3, translateX: 5, translateY: 5)
    }
    
    func testCreateCollageData() {#imageLiteral(resourceName: "testCreateCollage.1.png")
        //create associated data to a single image
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
