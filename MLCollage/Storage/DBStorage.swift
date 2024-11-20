//
//  DBStorage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/19/24.
//
import GRDB

class DBStorage: StorageProtocol {
    let databaseQueue: DatabaseQueue
    
    init(databaseQueue: DatabaseQueue) throws {
        self.databaseQueue = databaseQueue
        var migrator = DatabaseMigrator()
        migrator.registerMigration("Create table") { db in
            try db.create(table: "subjects") { table in
                table.primaryKey("id", .text) //the internal 'name' for each subject
                table.column("label", .text) //the string the user sets to represent each subject
            }
            try db.create(table: "subjectImages") { table in
                table.primaryKey("id", .text) //the internal 'name' for each subject
                table.column("image", .blob) //photo
                table.column("subjectID", .text) //the internal 'name' for each subject
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
        fatalError()
    }
    
    func write(settingsModel: SettingsModel) {
        fatalError()
    }
    
}
