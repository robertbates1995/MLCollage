//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import SwiftUI
import UIKit

@Observable
@MainActor
class Project {
    var title: String
    var settingsModel: SettingsModel {
        didSet {
            createBlueprints()
        }
    }
    var inputModel: InputModel {
        didSet {
            createBlueprints()
        }
    }
    var outputModel: OutputModel

    init() {
        title = "project title"
        settingsModel = SettingsModel()
        inputModel = InputModel(subjects: [:], backgrounds: [])
        outputModel = OutputModel(collages: [], factories: [])
    }

    init(
        title: String,
        inputModel: InputModel,
        settingsModel: SettingsModel,
        outputModel: OutputModel
    ) {
        self.title = title
        self.settingsModel = settingsModel
        self.inputModel = inputModel
        self.outputModel = outputModel
    }

    init(url: URL) throws {
        //this will find the data needed for the project
        //and populate project settings, subjects, and backgrounds
        let temp = url.lastPathComponent
        self.title = String(temp[..<temp.lastIndex(of: ".")!])
        //create json decoder
        let data = try Data(contentsOf: url)
        //use decoder to load settings
        self.settingsModel = try JSONDecoder().decode(
            SettingsModel.self, from: data)
        let url = url.deletingLastPathComponent()
        let manager = FileManager.default
        let backgrounds = try manager.contentsOfDirectory(
            atPath: url.appending(path: "backgrounds").path
        ).compactMap { fileName in
            UIImage(
                contentsOfFile: url.appending(path: "backgrounds/\(fileName)")
                    .path)
        }
        inputModel = InputModel(subjects: [:], backgrounds: backgrounds)
        outputModel = OutputModel(collages: [], factories: [])
    }

    func save(to url: URL) {
        let manager = FileManager.default
        do {
            let subjectsDir = url.appending(path: "subjects")
            let backgroundDir = url.appending(path: "backgrounds")
            let settingsFile = url.appending(path: "\(title).sett")
            //create directores to save to
            try manager.createDirectory(
                at: subjectsDir, withIntermediateDirectories: false)
            try manager.createDirectory(
                at: backgroundDir, withIntermediateDirectories: false)
            for i in inputModel.subjects {
                let subjectDir = subjectsDir.appending(path: i.key)
                try? manager.createDirectory(
                    at: subjectDir, withIntermediateDirectories: false)
                try saveToDir(dir: subjectDir, images: i.value.images)
            }
            try saveToDir(dir: backgroundDir, images: inputModel.backgrounds)

            let encoder = JSONEncoder()
            encoder.outputFormatting = .init(arrayLiteral: [
                .prettyPrinted, .sortedKeys,
            ])
            let output = try encoder.encode(settingsModel)
            try output.write(to: settingsFile)
        } catch {
            print("Unable to write images to disk")
        }
    }

    func saveToDir(dir: URL, images: [UIImage]) throws {
        var count = 1
        for i in images {
            //save like in export function
            if let data = i.pngData() {
                try data.write(to: dir.appending(path: "\(count).png"))
                //manager.createFile(atPath: dir.appending(path:"\(count).png").absoluteString, contents: data)
                count += 1
            }
        }
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
                    in: settingsModel
                        .translateLowerBound..<settingsModel.translateUpperBound)
                newMod.translateY = CGFloat.random(
                    in: settingsModel
                        .translateLowerBound..<settingsModel.translateUpperBound)
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
                in: settingsModel.translateLowerBound..<settingsModel.translateUpperBound)
            mod.translateY = CGFloat.random(
                in: settingsModel.translateLowerBound..<settingsModel.translateUpperBound)
        }
        return mod
    }
}

//make backgrounds into subjects

extension Project {
    static let mock = {
        var temp = Project(
        title: "MockProject",
        inputModel: InputModel.mock,
        settingsModel: .init(),
        outputModel: OutputModel.mock)
        temp.createBlueprints()
        return temp
    }()
}
