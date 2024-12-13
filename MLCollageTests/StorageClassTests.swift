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
    
    func testMockData() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
    }
    
    func testMigration() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        assertInlineSnapshot(of: sut.databaseQueue, as: .dumpContent(), record: false) {
            """
            sqlite_master
            CREATE TABLE "backgroundImages" ("id" TEXT PRIMARY KEY NOT NULL, "image" BLOB);
            CREATE TABLE "settings" ("id" TEXT PRIMARY KEY NOT NULL, "settings" BLOB);
            CREATE TABLE "subjects" ("id" TEXT PRIMARY KEY NOT NULL, "label" TEXT);
            CREATE TABLE "subjectsImages" ("id" TEXT PRIMARY KEY NOT NULL, "subjectsId" TEXT, "image" BLOB);

            backgroundImages

            settings

            subjects

            subjectsImages

            """
        }
    }
    
    func testAddSubject() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        let subject1 = Subject(label: "testSubject", images: [.apple1, .apple2])
        let subject2 = Subject(label: "testSubject2", images: [.banana1, .banana2])
        let expected = InputModel(subjects: [subject1, subject2])
        try sut.write(inputModel: expected)
        var actual = try sut.readInputModel()
        XCTAssertEqual(actual, expected)
        try sut.write(inputModel: expected)
        actual = try sut.readInputModel()
        XCTAssertEqual(actual, expected)
    }
    
    func testAddBackground() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        let expected = InputModel(backgrounds: [.crazyBackground1, .crazyBackground2])
        try sut.write(inputModel: expected)
        var actual = try sut.readInputModel()
        XCTAssertEqual(actual, expected)
        try sut.write(inputModel: expected)
        actual = try sut.readInputModel()
        XCTAssertEqual(actual, expected)
    }
    
    func testAddSettings() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        let expected = SettingsModel()
        let temp = try sut.readSettingsModel()
        expectNoDifference(temp, expected)
    }
    
    func testChangeSettings() throws {
        let sut = try DBStorage(databaseQueue: DatabaseQueue())
        try sut.write(settingsModel: SettingsModel())
        let expected = SettingsModel(numberOfEachSubject: 100)
        try sut.write(settingsModel: expected)
        let result = try sut.readSettingsModel()
        expectNoDifference(result, expected)
    }
}

extension InputModel: @retroactive Equatable {
    public static func == (lhs: MLCollage.InputModel, rhs: MLCollage.InputModel) -> Bool {
        if lhs.subjects != rhs.subjects { return false }
        return true
    }
}

extension Subject: @retroactive Equatable {
    public static func == (lhs: MLCollage.Subject, rhs: MLCollage.Subject) -> Bool {
        if lhs.id != rhs.id { return false }
        if lhs.label != rhs.label { return false }
        if lhs.images.map({ $0.pngData() }) != rhs.images.map({ $0.pngData() }) { return false }
        return true
    }
}
