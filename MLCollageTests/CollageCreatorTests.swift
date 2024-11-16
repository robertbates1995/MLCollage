//
//  CollageTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 7/31/24.
//

import CustomDump
import Foundation
import XCTest

@testable import MLCollage

@MainActor
final class CollageTests: XCTestCase {
    var appleImages: [UIImage] = [
        CIImage(image: .apple1)!.toUIImage(),
        CIImage(image: .apple2)!.toUIImage(),
        CIImage(image: .apple3)!.toUIImage(),
    ]

    var bannanaImages: [UIImage] = [
        CIImage(image: .banana1)!.toUIImage(),
        CIImage(image: .banana2)!.toUIImage(),
        CIImage(image: .banana3)!.toUIImage(),
    ]

    var pepperImages: [UIImage] = [
        CIImage(image: .pepper1)!.toUIImage(),
        CIImage(image: .pepper2)!.toUIImage(),
        CIImage(image: .pepper3)!.toUIImage(),
    ]

    func testProject() {
        var appleSubject = Subject(label: "apple", images: appleImages)
        var bannanaSubject = Subject(label: "bannana", images: bannanaImages)
        var pepperSubject = Subject(label: "pepper", images: pepperImages)
        
        var inputModel = InputModel(subjects: <#T##[String : Subject]#>, backgrounds: <#T##[UIImage]#>)
        var settingsModel = SettingsModel()
        var outputModel = OutputModel(collages: <#T##[Collage]#>, factories: <#T##[CollageBlueprint]#>)
        
        var project = Project(title: "Test Project", settings: <#T##SettingsModel#>, inputModel: <#T##InputModel#>, outputModel: <#T##OutputModel#>)
        
    }
}
