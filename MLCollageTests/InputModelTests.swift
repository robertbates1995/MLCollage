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
    var sut = InputModel()

    func testAddSubject() {
        let expected = InputModel(subjects: [.mock])
        sut.add(subject: .mock)
        XCTAssertEqual(sut, expected)
    }
    
    func testAddMultipleSubjects() {
        
    }
    
    func testRemoveSubject() {
        
    }
    
    func testRemoveMultipleSubjects() {
        
    }
    
    func testAddBackground() {
        
    }
    
    func testAddMultipleBackgrounds() {
        
    }
    
    func testRemoveBackground() {
        
    }
    
    func testRemoveMultipleBackgrounds() {
        
    }
    
    func testClearAll() {
        let expected = InputModel()
        var sut = InputModel.mock
        sut.clearAll()
        XCTAssertEqual(sut, expected)
    }
}
