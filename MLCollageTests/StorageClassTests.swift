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
        assertInlineSnapshot(of: sut.databaseQueue, as: .dumpContent(), record: false) {
            """
            sqlite_master
            CREATE TABLE "project" ("id" TEXT PRIMARY KEY NOT NULL, "label");

            project

            """
        }
    }
}
