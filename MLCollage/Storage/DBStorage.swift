import Foundation
//
//  DBStorage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/19/24.
//
import GRDB

struct BackgroundImage: FetchableRecord, PersistableRecord, Codable {
    static let databaseTableName: String = "backgroundImages"
    let id: String
    let image: Data
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
            try db.create(table: "settings") { table in
                table.primaryKey("id", .text) //the internal 'name' for each setting
                table.column("label", .text)  //the string the app uses to refer to each subject
                table.column("value", .text) // the value/range of the setting, as a string
            }
            
        }
        try migrator.migrate(databaseQueue)
    }

    func readTitle() throws -> String {
        databaseQueue.path
    }

    func readInputModel() throws -> InputModel {
        fatalError()
    }

    func readSettingsModel() throws -> SettingsModel {
        fatalError()
    }

    func write(inputModel: InputModel) {
        do {
            let foo = BackgroundImage(
                id: "imageID", image: "imageData".data(using: .utf8)!)
            try databaseQueue.write { db in
                try foo.insert(db)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func write(settingsModel: SettingsModel) {
        fatalError()
    }

}
