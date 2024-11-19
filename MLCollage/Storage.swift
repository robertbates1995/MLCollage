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
    
//    init(url: URL) throws {
//        //this will find the data needed for the project
//        //and populate project settings, subjects, and backgrounds
//        let temp = url.lastPathComponent
//        self.title = String(temp[..<temp.lastIndex(of: ".")!])
//        //create json decoder
//        let data = try Data(contentsOf: url)
//        //use decoder to load settings
//        self.settingsModel = try JSONDecoder().decode(
//            SettingsModel.self, from: data)
//        let url = url.deletingLastPathComponent()
//        let manager = FileManager.default
//        let backgrounds = try manager.contentsOfDirectory(
//            atPath: url.appending(path: "backgrounds").path
//        ).compactMap { fileName in
//            UIImage(
//                contentsOfFile: url.appending(path: "backgrounds/\(fileName)")
//                    .path)
//        }
//        inputModel = InputModel(subjects: [:], backgrounds: backgrounds)
//        outputModel = OutputModel(collages: [], factories: [])
//    }
//
//    func save(to url: URL) {
//        let manager = FileManager.default
//        do {
//            let subjectsDir = url.appending(path: "subjects")
//            let backgroundDir = url.appending(path: "backgrounds")
//            let settingsFile = url.appending(path: "\(title).sett")
//            //create directores to save to
//            try manager.createDirectory(
//                at: subjectsDir, withIntermediateDirectories: false)
//            try manager.createDirectory(
//                at: backgroundDir, withIntermediateDirectories: false)
//            for i in inputModel.subjects {
//                let subjectDir = subjectsDir.appending(path: i.key)
//                try? manager.createDirectory(
//                    at: subjectDir, withIntermediateDirectories: false)
//                try saveToDir(dir: subjectDir, images: i.value.images)
//            }
//            try saveToDir(dir: backgroundDir, images: inputModel.backgrounds)
//
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .init(arrayLiteral: [
//                .prettyPrinted, .sortedKeys,
//            ])
//            let output = try encoder.encode(settingsModel)
//            try output.write(to: settingsFile)
//        } catch {
//            print("Unable to write images to disk")
//        }
//    }
//
//    func saveToDir(dir: URL, images: [UIImage]) throws {
//        var count = 1
//        for i in images {
//            //save like in export function
//            if let data = i.pngData() {
//                try data.write(to: dir.appending(path: "\(count).png"))
//                //manager.createFile(atPath: dir.appending(path:"\(count).png").absoluteString, contents: data)
//                count += 1
//            }
//        }
//    }
}
