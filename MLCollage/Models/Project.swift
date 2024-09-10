//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

@Observable
class Project {
    var projectData: [Collage]
    var subjects: [Subject]
    var backgrounds: [CIImage]
    var title: String
    var settings: ProjectSettings
    
    init(projectData: [Collage] = [],
         subjects: [Subject] = [],
         backgrounds: [CIImage] = [],
         title: String = "project title",
         settings: ProjectSettings = ProjectSettings()
         ) {
        self.projectData = projectData
        self.subjects = subjects
        self.backgrounds = backgrounds
        self.title = title
        self.settings = settings
    }
    
//    //get this to work
//    init(url: URL) {
//        //this will find the data needed for the project 
//        //and populate project settings, subjects, and backgrounds
//        //backgrounds 
//    }
    
    func save(to url: URL) {
        for i in subjects {
            //create directory to save to
            //save like in export function
        }
        for i in backgrounds {
            //create directory to save to
            //save like in export function
        }
    }
    
    func export(to url: URL) {
        var count = 0
        do {
            try createJSON().data(using: .utf8)!.write(to: url.appendingPathComponent("anotations.json"))
        } catch {
            print("Unable to write image data to disk")
        }
        for i in projectData {
            if let data = i.image.pngData() {
                do {
                    try data.write(to: url.appendingPathComponent("\(count).png"))
                    count += 1
                } catch {
                    print("Unable to save image to disk")
                }
            }
        }
    }
    
    func createCollageSet() -> [Collage] {
        var set = [Collage]()
        let modifacations: [Modification] = createModList()
        for x in subjects {
            for y in backgrounds {
                if (settings.translate || settings.scale || settings.rotate || settings.flip) {
                    for z in appendableCollageSet(y, modificaitions: modifacations) {
                        set.append(z)
                    }
                } else {
                    set.append(contentsOf: appendableCollageSet(y, modificaitions: [Modification()]))
                }
            }
        }
        return set
    }
    
    func appendableCollageSet(_ background: CIImage, modificaitions: [Modification]) -> [Collage] {
        var set = [Collage]()
        for mod in modificaitions {
            for x in subjects {
                let modifiedSubject = x.modify(mod: mod, backgroundSize: background.extent.size)
                set.append(Collage.create(subject: modifiedSubject, background: background, title: "\(title)"))
            }
        }
        return set
    }
    
    func createModList(modifications: [Modification] = [Modification()]) -> [Modification] {
        var mods = modifications
        if settings.scale {
            for i in mods {
                var newMod = i
                newMod.scale = CGFloat.random(in: settings.scaleLowerBound..<settings.scaleUpperBound)
                mods.append(newMod)
            }
        }
        if settings.rotate {
            for i in mods {
                var newMod = i
                newMod.rotate = CGFloat.random(in: (settings.rotateLowerBound * 2 * .pi)..<(settings.rotateUpperBound * 2 * .pi))
                mods.append(newMod)
            }
        }
        if settings.flip {
            for i in mods {
                var newMod = i
                newMod.flipX = true
                mods.append(newMod)
                newMod.flipY = true
                mods.append(newMod)
                newMod.flipX = false
                mods.append(newMod)
            }
        }
        //translate should be applied last
        if settings.translate {
            for i in mods {
                var newMod = i
                newMod.translateX = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
                mods.append(newMod)
                newMod.translateY = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
                mods.append(newMod)
                newMod.translateX = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
                mods.append(newMod)
            }
        }
        return mods
    }
    
    func createRandomModList() -> [Modification] {
        var mods: [Modification] = []
        for _ in 0..<settings.population {
            mods.append(randomMod())
        }
        return mods
    }
    
    func randomMod() -> Modification {
        var mod = Modification()
        if settings.scale {
            mod.scale = CGFloat.random(in: settings.scaleLowerBound..<settings.scaleUpperBound)
        }
        if settings.rotate {
            mod.rotate = CGFloat.random(in: (settings.rotateLowerBound * 2 * .pi)..<(settings.rotateUpperBound * 2 * .pi))
        }
        if settings.flip {
            mod.flipX = Bool.random()
            mod.flipY = Bool.random()
        }
        if settings.translate {
            mod.translateX = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
            mod.translateY = CGFloat.random(in: settings.translateLowerBound..<settings.translateUpperBound)
        }
        return mod
    }
    
    func createJSON() throws -> String  {
        projectData = createCollageSet()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
        var count = 0
        let annotationArray = projectData.map {
            count += 1
            return CollageData(annotation: $0.annotations, imagefilename: "\(count - 1).png")
        }
        let output = try encoder.encode(annotationArray)
        return String.init(data: output, encoding: .utf8)!
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
