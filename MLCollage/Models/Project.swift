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
            try? storage.write(settingsModel: settingsModel)
        }
    }
    var inputModel: InputModel {
        didSet {
            outputModel.blueprints = blueprintFactory.createBlueprints(inputModel, settingsModel)
            do {
                try storage.write(inputModel: inputModel)
            } catch {
                print(error)
            }
        }
    }
    var outputModel: OutputModel
    var storage: StorageProtocol
    let blueprintFactory: BlueprintFactory

    init(storage: StorageProtocol) {
        title = (try? storage.readPath()) ?? "new_project"
        settingsModel = (try? storage.readSettingsModel()) ?? SettingsModel()
        inputModel = (try? storage.readInputModel()) ?? InputModel()
        outputModel = OutputModel()
        blueprintFactory = BlueprintFactory()
        self.storage = storage
        outputModel.blueprints = blueprintFactory.createBlueprints(inputModel, settingsModel)
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
