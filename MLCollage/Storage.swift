//
//  Storage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/18/24.
//

@MainActor
class Storage {
    var title: String
    var inputModel: InputModel
    var settingsModel: SettingsModel
    var outputModel: OutputModel

    init(
        title: String = "New_Project",
        inputModel: InputModel = InputModel(subjects: [:], backgrounds: []),
        settingsModel: SettingsModel = SettingsModel(),
        outputModel: OutputModel? = nil
    ) {
        self.title = title
        self.inputModel = inputModel
        self.settingsModel = settingsModel
        if let outputModel = outputModel{
            self.outputModel = outputModel
        } else {
            self.outputModel = OutputModel(collages: [], factories: [])
        }
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

    func readOutputModel() -> OutputModel {
        return outputModel
    }
}
