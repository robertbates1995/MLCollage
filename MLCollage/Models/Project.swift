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
            createBlueprints()
            storage.write(settingsModel: settingsModel)
        }
    }
    var inputModel: InputModel {
        didSet {
            createBlueprints()
            storage.write(inputModel: inputModel)
        }
    }
    var outputModel: OutputModel
    var storage: StorageProtocol

    init(storage: StorageProtocol) {
        title = (try? storage.readTitle()) ?? "new_project"
        settingsModel = (try? storage.readSettingsModel()) ?? SettingsModel()
        inputModel = (try? storage.readInputModel()) ?? InputModel(subjects: [:], backgrounds: [])
        outputModel = OutputModel(collages: [], factories: [])
        self.storage = storage
    }

    func createBlueprints() {
        var set = [CollageBlueprint]()
        for subject in inputModel.subjects.values {
            var count = 1
            for mod in createModList() {
                guard let background = inputModel.backgrounds.randomElement(),
                    let image = subject.images.randomElement()
                else {
                    continue
                }
                let blueprint = CollageBlueprint(
                    mod: mod, subjectImage: image, background: background,
                    label: subject.label,
                    fileName: "\(subject.label)_\(count).png")
                set.append(blueprint)
                count += 1
            }
        }
        outputModel.blueprints = set
    }

    func createModList(modifications: [Modification] = [Modification()])
        -> [Modification]
    {
        (1...Int(settingsModel.population)).map { _ in
            var newMod = Modification()
            if settingsModel.scale {
                newMod.scale = CGFloat.random(
                    in: settingsModel.scaleLowerBound..<settingsModel.scaleUpperBound)
            }
            if settingsModel.rotate {

                newMod.rotate = CGFloat.random(
                    in: (settingsModel.rotateLowerBound * 2 * .pi)..<(settingsModel
                        .rotateUpperBound * 2 * .pi))
            }
            if settingsModel.flipHorizontal {
                newMod.flipX = Bool.random()
                newMod.flipY = Bool.random()
            }
            //translate should be applied last
            if settingsModel.translate {
                newMod.translateX = CGFloat.random(
                    in: 0.0..<1.0)
                newMod.translateY = CGFloat.random(
                    in: 0.0..<1.0)
            }
            return newMod
        }
    }

    func randomMod() -> Modification {
        var mod = Modification()
        if settingsModel.scale {
            mod.scale = CGFloat.random(
                in: settingsModel.scaleLowerBound..<settingsModel.scaleUpperBound)
        }
        if settingsModel.rotate {
            mod.rotate = CGFloat.random(
                in: (settingsModel.rotateLowerBound * 2 * .pi)..<(settingsModel
                    .rotateUpperBound * 2 * .pi))
        }
        if settingsModel.flipHorizontal {
            mod.flipX = Bool.random()
        }
        if settingsModel.flipVertical {
            mod.flipY = Bool.random()
        }
        if settingsModel.translate {
            mod.translateX = CGFloat.random(
                in: 0.0..<1.0)
            mod.translateY = CGFloat.random(
                in: 0.0..<1.0)
        }
        return mod
    }
}

//make backgrounds into subjects
extension Project {
    static let mock = {
        var temp = Project(storage: MockStorage(title: "MockProject",
                                       inputModel: InputModel.mock,
                                       settingsModel: .init()))
        temp.createBlueprints()
        return temp
    }()
}
