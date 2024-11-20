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
    func testEmpty() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        let title = try sut.readTitle()
        XCTAssertEqual(title, ":memory:")
    }
    
    func testMigration() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        assertInlineSnapshot(of: sut.databaseQueue, as: .dumpContent(), record: true) {
            """
            sqlite_master
            CREATE TABLE "subjectImages" ("id" TEXT PRIMARY KEY NOT NULL, "image" BLOB, "subjectID" TEXT);
            CREATE TABLE "subjects" ("id" TEXT PRIMARY KEY NOT NULL, "label" TEXT);

            subjectImages

            subjects

            """
        }
    }
    
    func testAddSubject() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        sut.write(inputModel: .init(subjects: ["testSubject": .init(label: "testSubject")], backgrounds: []))
        assertInlineSnapshot(of: sut.databaseQueue, as: .dumpContent(), record: true) {
            """
            sqlite_master
            CREATE TABLE "backgroundImages" ("id" TEXT PRIMARY KEY NOT NULL, "image" BLOB);
            CREATE TABLE "subjectImages" ("id" TEXT PRIMARY KEY NOT NULL, "image" BLOB, "subjectID" TEXT);
            CREATE TABLE "subjects" ("id" TEXT PRIMARY KEY NOT NULL, "label" TEXT);

            backgroundImages
            - id: 'imageID'
              image: X'696D61676544617461'

            subjectImages

            subjects

            """
        }
    }
    
}
