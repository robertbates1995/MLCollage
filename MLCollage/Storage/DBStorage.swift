import Foundation
//
//  DBStorage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/19/24.
//
import GRDB

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
            try db.create(table: "subjectImages") { table in
                table.primaryKey("id", .text)  //the image id
                table.column("subjectID", .text) //the foregn key
                table.column("image", .blob)  //one image of a subject
            }
            try db.create(table: "backgroundImages") { table in
                table.primaryKey("id", .text)  //the internal 'name' for each background
                table.column("image", .blob)  //one background image
            }
            try db.create(table: "settingsModel") { table in
                table.primaryKey("id", .text) //the internal 'name' for each setting
                table.column("label", .text)  //the string the app uses to refer to each subject
                table.column("value", .text) // the value/range of the setting, as a string
            }
        }
        try migrator.migrate(databaseQueue)
    }

    func readPath() throws -> String {
        databaseQueue.path
    }

    func readInputModel() throws -> InputModel {
        try databaseQueue.read { db in
            let subjects = try DBSubject.fetchAll(db).map { dbsubject in
                Subject(id: dbsubject.id, label: dbsubject.label, images: [])
            }
            return InputModel(subjects: subjects)
        }
    }

    func readSettingsModel() throws -> SettingsModel {
        fatalError()
    }

    func write(inputModel: InputModel) {
        do {
            try databaseQueue.write { db in
                try DBSubject.deleteAll(db) //wipe database
                for subject in inputModel.subjects { //loop over all subjects
                    var temp = DBSubject(id: subject.id, label: subject.label) //create new subject
                    try temp.insert(db) //insert new subject
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func write(settingsModel: SettingsModel) {
        fatalError()
    }

}
