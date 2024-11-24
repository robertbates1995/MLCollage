//
//  StorageProtocol.swift
//  MLCollage
//
//  Created by Robert Bates on 11/18/24.
//

protocol StorageProtocol {
    func readPath() throws -> String
    func readInputModel() throws -> InputModel
    func readSettingsModel() throws -> SettingsModel
    func write(inputModel: InputModel)
    func write(settingsModel: SettingsModel)
}

