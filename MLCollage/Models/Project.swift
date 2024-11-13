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
    var settings: ProjectSettings
    var inputModel: InputModel
    var outputModel: OutputModel

    init() {
        title = "project title"
        settings = ProjectSettings()
        inputModel = InputModel(subjects: [:], backgrounds: [])
        outputModel = OutputModel(collages: [], factories: [])
    }

    init(
        title: String,
        settings: ProjectSettings,
        inputModel: InputModel,
        outputModel: OutputModel
    ) {
        self.title = title
        self.settings = settings
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
        self.settings = try JSONDecoder().decode(
            ProjectSettings.self, from: data)
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
            let output = try encoder.encode(settings)
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

    func createCollageSet() -> [Collage] {
        var set = [Collage]()
        for subject in inputModel.subjects.values {
            var count = 1
            for mod in createModList() {
                guard let background = inputModel.backgrounds.randomElement(),
                    let image = subject.images.randomElement()
                else {
                    continue
                }
                let factory = CollageBlueprint(
                    mod: mod, subject: image, background: background,
                    label: subject.label,
                    fileName: "\(subject.label)_\(count).png")
                set.append(factory.create())
                count += 1
            }
        }
        return set
    }

    func createModList(modifications: [Modification] = [Modification()])
        -> [Modification]
    {
        (1...Int(settings.population)).map { _ in
            var newMod = Modification()
            if settings.scale {
                newMod.scale = CGFloat.random(
                    in: settings.scaleLowerBound..<settings.scaleUpperBound)
            }
            if settings.rotate {

                newMod.rotate = CGFloat.random(
                    in: (settings.rotateLowerBound * 2 * .pi)..<(settings
                        .rotateUpperBound * 2 * .pi))
            }
            if settings.flipHorizontal {
                newMod.flipX = Bool.random()
                newMod.flipY = Bool.random()
            }
            //translate should be applied last
            if settings.translate {
                newMod.translateX = CGFloat.random(
                    in: settings
                        .translateLowerBound..<settings.translateUpperBound)
                newMod.translateY = CGFloat.random(
                    in: settings
                        .translateLowerBound..<settings.translateUpperBound)
            }
            return newMod
        }
    }

    func randomMod() -> Modification {
        var mod = Modification()
        if settings.scale {
            mod.scale = CGFloat.random(
                in: settings.scaleLowerBound..<settings.scaleUpperBound)
        }
        if settings.rotate {
            mod.rotate = CGFloat.random(
                in: (settings.rotateLowerBound * 2 * .pi)..<(settings
                    .rotateUpperBound * 2 * .pi))
        }
        if settings.flipHorizontal {
            mod.flipX = Bool.random()
        }
        if settings.flipVertical {
            mod.flipY = Bool.random()
        }
        if settings.translate {
            mod.translateX = CGFloat.random(
                in: settings.translateLowerBound..<settings.translateUpperBound)
            mod.translateY = CGFloat.random(
                in: settings.translateLowerBound..<settings.translateUpperBound)
        }
        return mod
    }
}

//make backgrounds into subjects

extension Project {
    static let mock = Project(
        title: "MockProject",
        settings: .init(),
        inputModel: InputModel.mock,
        outputModel: OutputModel.mock)
}
