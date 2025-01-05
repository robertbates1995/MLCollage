import Foundation
//
//  DBStorage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/19/24.
//
import GRDB
import SwiftUI

struct DBBackgroundImages: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "backgroundImages"
    let id: String
    let image: Data
    
    func asImage() -> UIImage {
        //turn image into UIImage
        return UIImage(data: image)!
    }
}

struct DBSubject: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "subjects"
    var id: String
    var label: String
}

struct DBSubjectImage: Codable, FetchableRecord, PersistableRecord {
    static let databaseTableName: String = "subjectsImages"
    var subjectsId: String
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
                table.column("subjectsId", .text)  //the foregn key
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
            let subjectImages = try DBSubjectImage.fetchAll(db)
            let subjects = try DBSubject.fetchAll(db).map { dbSubject in
                Subject(id: dbSubject.id, label: dbSubject.label, images: subjectImages.filter({ $0.subjectsId == dbSubject.id }).map {
                    MLCImage(id: $0.id, uiImage: $0.asImage())
                })
            }
            let backgrounds = try DBBackgroundImages.fetchAll(db).map {
                MLCImage(id: $0.id, uiImage: $0.asImage())
            }
            return InputModel(subjects: subjects, backgrounds: backgrounds)
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

    //TODO: DO THE SAME THING AS writeBackgrounds
    //make sure to not be re-writing images
    fileprivate func writeSubjects(_ db: Database, inputModel: InputModel) throws {
        for subject in inputModel.subjects {  //loop over all subjects
            if try DBSubjectImage.exists(db, key: subject.id) { //if already in table, continue
                continue
            }
            let temp = DBSubject(id: subject.id, label: subject.label)  //create new subject
            try temp.insert(db)  //insert new subject
            for image in subject.images { //populate images for current subject
                guard let image = image.uiImage.pngData() else {
                    continue
                }
                try DBSubjectImage(subjectsId: subject.id, id: "", image: image).insert(db)
            }
            for i in try DBSubjectImage.fetchAll(db) {
                if subject.images.map({$0.id}).contains(i.id) {
                    continue
                }
                try i.delete(db)
            }
        }
    }
    
    fileprivate func writeBackgrounds(_ db: Database, inputModel: InputModel) throws {
        for background in inputModel.backgrounds {
            if try DBBackgroundImages.exists(db, key: background.id) {
                continue
            }
            guard let image = background.uiImage.pngData() else {
                continue
            }
            try DBBackgroundImages(id: background.id, image: image).insert(db)
        }
        for i in try DBBackgroundImages.fetchAll(db) {
            if inputModel.backgrounds.map({$0.id}).contains(i.id) {
                continue
            }
            try i.delete(db)
        }
    }
    
    func write(inputModel: InputModel) throws {
        try databaseQueue.write { db in
            try writeSubjects(db, inputModel: inputModel)
            try writeBackgrounds(db, inputModel: inputModel)
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
