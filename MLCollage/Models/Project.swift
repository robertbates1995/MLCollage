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
            blueprintFactory.createBlueprints()
            storage.write(settingsModel: settingsModel)
        }
    }
    var inputModel: InputModel {
        didSet {
            blueprintFactory.createBlueprints()
            storage.write(inputModel: inputModel)
        }
    }
    var outputModel: OutputModel
    var storage: StorageProtocol
    let blueprintFactory: BlueprintFactory

    init(storage: StorageProtocol) {
        title = (try? storage.readTitle()) ?? "new_project"
        settingsModel = (try? storage.readSettingsModel()) ?? SettingsModel()
        inputModel = (try? storage.readInputModel()) ?? InputModel()
        outputModel = OutputModel()
        blueprintFactory = BlueprintFactory(inputModel: inputModel, settingsModel: settingsModel, outputModel: outputModel)
        self.storage = storage
    }

#warning("TODO: migrate non-essential funcs out of project to new file")
}

//make backgrounds into subjects
extension Project {
    static let mock = {
        var temp = Project(storage: MockStorage(title: "MockProject",
                                       inputModel: InputModel.mock,
                                       settingsModel: .init()))
        temp.blueprintFactory.createBlueprints()
        return temp
    }()
}
