//
//  Storage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/18/24.
//

import Foundation
import UIKit

class Storage: StorageProtocol {
    let folder: URL

    init(folder: URL) {
        self.folder = folder
    }

    func readTitle() throws -> String {
        return folder.lastPathComponent
    }

    func readInputModel() throws -> InputModel {
        //this will find the data needed for the project
        //and populate project settings, subjects, and backgrounds
        //create json decoder
        let manager = FileManager.default
        let backgrounds = try manager.contentsOfDirectory(
            atPath: folder.appending(path: "backgrounds").path
        ).compactMap { fileName in
            UIImage(
                contentsOfFile: folder.appending(
                    path: "backgrounds/\(fileName)"
                )
                .path)
        }
        return InputModel(subjects: [:], backgrounds: backgrounds)
    }

    func readSettingsModel() throws -> SettingsModel {
        let data = try Data(
            contentsOf: folder.appending(component: "settings.json"))
        //use decoder to load settings
        return try JSONDecoder().decode(SettingsModel.self, from: data)
    }

    func write(inputModel: InputModel) {
        let manager = FileManager.default
        do {
            let subjectsDir = folder.appending(path: "subjects")
            let backgroundDir = folder.appending(path: "backgrounds")
            try? manager.createDirectory(
                at: subjectsDir, withIntermediateDirectories: false)
            try? manager.createDirectory(
                at: backgroundDir, withIntermediateDirectories: false)
            for i in inputModel.subjects {
                let subjectDir = subjectsDir.appending(path: i.key)
                try? manager.createDirectory(
                    at: subjectDir, withIntermediateDirectories: false)
                try saveToDir(dir: subjectDir, images: i.value.images)
            }
            try saveToDir(dir: backgroundDir, images: inputModel.backgrounds)
        } catch {
            print(error.localizedDescription)
        }
    }

    func write(settingsModel: SettingsModel) {
        let manager = FileManager.default
        do {
            let settingsFile = folder.appending(path: "settings.json")
            let encoder = JSONEncoder()
            encoder.outputFormatting = .init(arrayLiteral: [
                .prettyPrinted, .sortedKeys,
            ])
            let output = try encoder.encode(settingsModel)
            try output.write(to: settingsFile)
        } catch {
            print(error.localizedDescription)
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
}
