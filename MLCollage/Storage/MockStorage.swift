//
//  Storage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/18/24.
//

class MockStorage: StorageProtocol {
    var title: String
    var inputModel: InputModel
    var settingsModel: SettingsModel

    init(
        title: String = "New_Project",
        inputModel: InputModel = InputModel(subjects: [:], backgrounds: []),
        settingsModel: SettingsModel = SettingsModel()
    ) {
        self.title = title
        self.inputModel = inputModel
        self.settingsModel = settingsModel
    }

    func write(title: String) {
        self.title = title
    }

    func write(inputModel: InputModel) {
        self.inputModel = inputModel
    }

    func write(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
    }

    func readTitle() -> String {
        return title
    }

    func readInputModel() -> InputModel {
        return inputModel
    }

    func readSettingsModel() -> SettingsModel {
        return settingsModel
    }
}
