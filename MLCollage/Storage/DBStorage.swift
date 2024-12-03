import Foundation
//
//  DBStorage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/19/24.
//
import GRDB
import SwiftUI

struct DBBackgroundImage: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "backgroundImage"
    let id: String
    let image: Data
}

struct DBSubject: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "subjects"
    var id: String
    var label: String
}

struct DBSubjectImage: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "subjectsImages"
    var id: String
    var image: Data

    func asImage() -> UIImage {
        //turn image into UIImage
        return UIImage(data: image)!
    }
}

struct DBSettings: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "settings"
    var id: String
    var settings: Data
}

class DBStorage: StorageProtocol {
    let databaseQueue: DatabaseQueue

    init(databaseQueue: DatabaseQueue) throws {
        self.databaseQueue = databaseQueue
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Create table") { db in
            try db.create(table: "subjects") { table in
                table.primaryKey("id", .text)  //the internal 'name' for each subject
                table.column("label", .text)  //the string the user sets to represent each subject
            }
            try db.create(table: "subjectsImages") { table in
                table.primaryKey("id", .text)  //the image id
                table.column("subjectID", .text)  //the foregn key
                table.column("image", .blob)  //one image of a subject
            }
            try db.create(table: "backgroundImages") { table in
                table.primaryKey("id", .text)  //the internal 'name' for each background
                table.column("image", .blob)  //one background image
            }
            try db.create(table: "settings") { table in
                table.primaryKey("id", .text)  //the internal 'name' for each setting
                table.column("settings", .blob)  // the value/range of the setting, as a string
            }
        }
        try migrator.migrate(databaseQueue)
    }

    func readPath() throws -> String {
        databaseQueue.path
    }

    func readInputModel() throws -> InputModel {
        try databaseQueue.read { db in
            let subjects = try DBSubject.fetchAll(db).map { dbSubject in
                Subject(id: dbSubject.id, label: dbSubject.label, images: [])
            }
            let subjectImages = try DBSubjectImage.fetchAll(db).map {
                dbSubjectImage in
                Image(uiImage: dbSubjectImage.asImage())
            }
            return InputModel(subjects: subjects)
        }
    }

    func readSettingsModel() throws -> SettingsModel {
        try databaseQueue.read { db in
            let settings = try DBSettings.fetchOne(db)
            if let settings = settings {
                return try JSONDecoder().decode(
                    SettingsModel.self, from: settings.settings)
            } else {
                return SettingsModel()
            }
        }
    }

    func write(inputModel: InputModel) throws {
        try databaseQueue.write { db in
            try DBSubject.deleteAll(db)  //wipe database
            for subject in inputModel.subjects {  //loop over all subjects
                let temp = DBSubject(id: subject.id, label: subject.label)  //create new subject
                try temp.insert(db)  //insert new subject
            }
        }
    }

    func write(settingsModel: SettingsModel) throws {
        try databaseQueue.write { db in
            let encoder = JSONEncoder()
            encoder.outputFormatting = .init(arrayLiteral: [
                .prettyPrinted, .sortedKeys,
            ])
            let output = try encoder.encode(settingsModel)
            let temp = DBSettings(id: "SettingsID", settings: output) //create settings object
            try temp.upsert(db)  //upsert settings
        }
    }

}
