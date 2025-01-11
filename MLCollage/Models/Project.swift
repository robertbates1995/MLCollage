//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import SwiftUI
import UIKit
import GRDB

@Observable
@MainActor
class Project {
    var title: String
    var settingsModel: SettingsModel {
        didSet {
            outputModel.blueprints = blueprintFactory.createBlueprints(inputModel, settingsModel)
            outputModel.outputSize = settingsModel.outputSize
            writeSettings()
        }
    }
    var inputModel: InputModel {
        didSet {
            outputModel.blueprints = blueprintFactory.createBlueprints(inputModel, settingsModel)
            writeInputs()
        }
    }
    var outputModel: OutputModel
    var storage: StorageProtocol
    let blueprintFactory: BlueprintFactory
    var settingsTask: Task<Void, Never>?
    var inputTask: Task<Void, Never>?

    init(storage: StorageProtocol) {
        title = (try? storage.readPath()) ?? "new_project"
        settingsModel = (try? storage.readSettingsModel()) ?? SettingsModel()
        inputModel = (try? storage.readInputModel()) ?? InputModel()
        outputModel = OutputModel()
        blueprintFactory = BlueprintFactory()
        self.storage = storage
        outputModel.blueprints = blueprintFactory.createBlueprints(inputModel, settingsModel)
    }
    
    func writeSettings() {
        let settingsModel = settingsModel
        let storage = storage
        settingsTask?.cancel()
        settingsTask = Task.detached {
            try? storage.write(settingsModel: settingsModel)
        }
    }
    
    func writeInputs() {
        let inputModel = inputModel
        let storage = storage
        inputTask?.cancel()
        inputTask = Task.detached {
            do {
                try storage.write(inputModel: inputModel)
            } catch {
                print(error)
            }
        }
    }
}

extension Project {
    static let mock = {
        var temp = Project(storage: MockStorage(title: "MockProject",
                                       inputModel: InputModel.mock,
                                       settingsModel: .init()))
        return temp
    }()
}
