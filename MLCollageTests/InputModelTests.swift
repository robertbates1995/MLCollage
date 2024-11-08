//
//  InputModelTests.swift
//  MLCollageTests
//
//  Created by Robert Bates on 11/7/24.
//

import XCTest
@testable import MLCollage
import SwiftUI

final class InputModelTests: XCTestCase {
    let sut = InputModel(subjects: [:], backgrounds: [])

    func testAddSubject() {
        let newSubject = sut.newSubject
        XCTAssertEqual(newSubject.label, "New Subject")
        sut.add(subject: sut.newSubject)
        XCTAssertEqual(sut.newSubject.label, "New Subject 2")
        sut.add(subject: newSubject)
        XCTAssertEqual(sut.newSubject.label, "New Subject 3")
        XCTAssertEqual(sut.subjects.values.map(\.label).sorted(by: { $0 > $1 }), ["New Subject 2", "New Subject"])
        //add coverage for other two add functions
    }
    
    func testAddImage() {
        var subject = Subject(label: "test")
        let image = UIImage(resource: .apple1)
        let view = SubjectView(images: Binding(get: {subject.images}, set: {subject.images = $0}))
        view.addImage(image)
        XCTAssertEqual(subject.images.count, 1)
    }
}
