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

@MainActor
final class CollageTests: XCTestCase {
    let inputModel: InputModel = .init(subjects: ["apple":.init(label: <#T##String#>, images: <#T##[UIImage]#>)], backgrounds: <#T##[UIImage]#>)
    let outputModel: OutputModel = .init(collages: [Collage(image: <#T##UIImage#>, json: <#T##CreateMLFormat#>)], factories: [])
    
    func testOutputFile() {
        var appleImages = [CIImage(image: .apple1)!.toUIImage(),
                           CIImage(image: .apple2)!.toUIImage(),
                           CIImage(image: .apple3)!.toUIImage()]
        let appleSubject = Subject(label: "apple", images: appleImages)
        
        let outputModel = OutputModel(collages: <#T##[Collage]#>, factories: <#T##[CollageBlueprint]#>)
    }
}
