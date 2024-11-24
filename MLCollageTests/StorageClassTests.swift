//
//  StorageClassTests.swift
//  MLCollage
//
//  Created by Robert Bates on 11/19/24.
//

import CoreImage.CIFilterBuiltins
import CustomDump
import Foundation
import SnapshotTesting
import InlineSnapshotTesting
import UIKit
import XCTest
import GRDB
import GRDBSnapshotTesting

@testable import MLCollage

@MainActor
final class StorageClassTests: XCTestCase {
    func testReadTitle() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        let title = try sut.readPath()
        XCTAssertEqual(title, ":memory:")
    }
    
    func testMigration() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        assertInlineSnapshot(of: sut.databaseQueue, as: .dumpContent(), record: false) {
            """
            sqlite_master
            CREATE TABLE "backgroundImages" ("id" TEXT PRIMARY KEY NOT NULL, "image" BLOB);
            CREATE TABLE "settingsModel" ("id" TEXT PRIMARY KEY NOT NULL, "label" TEXT, "value" TEXT);
            CREATE TABLE "subjectImages" ("id" TEXT PRIMARY KEY NOT NULL, "subjectID" TEXT, "image" BLOB);
            CREATE TABLE "subjects" ("id" TEXT PRIMARY KEY NOT NULL, "label" TEXT);

            backgroundImages

            settingsModel

            subjectImages

            subjects

            """
        }
    }
    
    func testAddSubject() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        let expected = InputModel(subjects: ["testSubject": .init(label: "testSubject")], backgrounds: [])
        sut.write(inputModel: expected)
        let actual = try sut.readInputModel()
        XCTAssertEqual(actual, expected)
    }
}

extension InputModel: @retroactive Equatable {
    public static func == (lhs: MLCollage.InputModel, rhs: MLCollage.InputModel) -> Bool {
        if lhs.subjects.map(\.value.id) != rhs.subjects.map(\.value.id) { return false }
        if lhs.subjects.map(\.value.label) != rhs.subjects.map(\.value.label) { return false }
        return true
    }
}
