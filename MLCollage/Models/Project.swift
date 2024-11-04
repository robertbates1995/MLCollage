//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit
import SwiftUI

@Observable
class Project {
    var projectData: [Collage]
    var subjects: [Subject]
    var title: String
    var settings: ProjectSettings
    var inputModel: InputModel
    
    init(projectData: [Collage] = [],
         subjects: [Subject] = [],
         title: String = "project title",
         settings: ProjectSettings = ProjectSettings(),
         inputModel: InputModel = InputModel(subjects: [:], backgrounds: [])
    ) {
        self.projectData = projectData
        self.subjects = subjects
        self.title = title
        self.settings = settings
        self.inputModel = inputModel
    }
    
    init(url: URL) throws {
        //this will find the data needed for the project
        //and populate project settings, subjects, and backgrounds
        let temp = url.lastPathComponent
        self.title = String(temp[..<temp.lastIndex(of: ".")!])
        //create json decoder
        let data = try Data(contentsOf: url)
        //use decoder to load settings
        self.settings = try JSONDecoder().decode(ProjectSettings.self, from: data)
        let url = url.deletingLastPathComponent()
        let manager = FileManager.default
        self.projectData = []
        self.subjects = try manager.contentsOfDirectory(atPath: url.appending(path: "subjects").path).flatMap { label in
            try manager.contentsOfDirectory(atPath: url.appending(path:"subjects/\(label)").path).map { image in
                Subject(image: UIImage(contentsOfFile: url.appending(path:"subjects/\(label)/\(image)").path)!.toCIImage(), label: label)
            }
        }
        let backgrounds = try manager.contentsOfDirectory(atPath: url.appending(path:"backgrounds").path).compactMap { fileName in
            UIImage(contentsOfFile: url.appending(path:"backgrounds/\(fileName)").path)
        }
        inputModel = InputModel(subjects: [:], backgrounds: backgrounds)
    }
    
    func save(to url: URL) {
        let manager = FileManager.default
        do {
            let subjectsDir = url.appending(path:"subjects")
            let backgroundDir = url.appending(path:"backgrounds")
            let settingsFile = url.appending(path:"\(title).sett")
            //create directores to save to
            try manager.createDirectory(at: subjectsDir, withIntermediateDirectories: false)
            try manager.createDirectory(at: backgroundDir, withIntermediateDirectories: false)
            for i in inputModel.subjects {
                let subjectDir = subjectsDir.appending(path:i.key)
                try? manager.createDirectory(at: subjectDir, withIntermediateDirectories: false)
                try saveToDir(dir: subjectDir, images: i.value.images)
            }
            try saveToDir(dir: backgroundDir, images: inputModel.backgrounds)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
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
                try data.write(to: dir.appending(path:"\(count).png"))
                //manager.createFile(atPath: dir.appending(path:"\(count).png").absoluteString, contents: data)
                count += 1
            }
        }
    }
    
    func export(to url: URL) {
        var count = 0
        do {
            try createJSON().write(to: url.appending(path:"anotations.json"))
        } catch {
            print("Unable to write image data to disk")
        }
        for i in projectData {
            if let data = UIImage(ciImage: i.image).pngData() {
                do {
                    try data.write(to: url.appending(path:"\(count).png"))
                    count += 1
                } catch {
                    print("Unable to save image to disk")
                }
            }
        }
    }
    
    func createCollageSet() -> [Collage] {
        var set = [Collage]()
        for x in subjects {
            for mod in createModList() {
                guard let background = inputModel.backgrounds.randomElement()?.toCIImage() else {
                    continue
                }
                let modifiedSubject = x.modify(mod: mod, backgroundSize: background.extent.size)
                set.append(Collage.create(subject: modifiedSubject, background: background, title: "\(title)"))
            }
        }
        return set
    }
    
    func createModList(modifications: [Modification] = [Modification()]) -> [Modification] {
        (1...Int(settings.population)).map { _ in
            var newMod = Modification()
            if settings.scale {
                newMod.scale = CGFloat.random(in: settings.scaleLowerBound..<settings.scaleUpperBound)
            }
            if settings.rotate {
                
                newMod.rotate = CGFloat.random(in: (settings.rotateLowerBound * 2 * .pi)..<(settings.rotateUpperBound * 2 * .pi))
            }
            if settings.flipHorizontal {
                newMod.flipX = Bool.random()
                newMod.flipY = Bool.random()
            }
            //translate should be applied last
            if settings.translate {
                newMod.translateX = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
                newMod.translateY = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
            }
            return newMod
        }
    }
    
    func randomMod() -> Modification {
        var mod = Modification()
        if settings.scale {
            mod.scale = CGFloat.random(in: settings.scaleLowerBound..<settings.scaleUpperBound)
        }
        if settings.rotate {
            mod.rotate = CGFloat.random(in: (settings.rotateLowerBound * 2 * .pi)..<(settings.rotateUpperBound * 2 * .pi))
        }
        if settings.flipHorizontal {
            mod.flipX = Bool.random()
        }
        if settings.flipVertical {
            mod.flipY = Bool.random()
        }
        if settings.translate {
            mod.translateX = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
            mod.translateY = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
        }
        return mod
    }
    
    func createJSON() -> Data  {
        projectData = createCollageSet()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
        var count = 0
        let annotationArray = projectData.map {
            count += 1
            return CollageData(annotation: $0.annotations, imagefilename: "\(count - 1).png")
        }
        let output = try! encoder.encode(annotationArray)
        //return as data(using: .utf8)!
        return output
    }
}

struct Modification {
    var translateX: CGFloat = 0.0
    var translateY: CGFloat = 0.0
    var scale: CGFloat = 1.0
    var rotate: CGFloat = 0.0
    var flipX: Bool = false
    var flipY: Bool = false
}

//make backgrounds into subjects

extension Project {
    static let mock =  Project(subjects: [Subject(image: CIImage(image: .apple1)!, label: "MockLabel1"),
                                          Subject(image: CIImage(image: .apple2)!, label: "MockLabel2"),
                                          Subject(image: CIImage(image: .apple3)!, label: "MockLabel3"),],
                               title: "MockProject",
                               settings: .init(),
                               inputModel: InputModel.mock
    )
}
