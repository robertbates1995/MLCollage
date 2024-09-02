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
    var population: CGFloat
    var translate: Bool
    var translateLowerBound: CGFloat
    var translateUpperBound: CGFloat
    var scale: Bool
    var scaleLowerBound: CGFloat
    var scaleUpperBound: CGFloat
    var rotate: Bool
    var rotateLowerBound: CGFloat
    var rotateUpperBound: CGFloat
    var flip: Bool
    let creator = CollageCreator()
    
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
    
    
    init(projectData: [Collage] = [],
         subjects: [Subject] = [],
         backgrounds: [CIImage] = [],
         title: String = "project title",
         population: CGFloat = 1,
         translate: Bool = false,
         translateLowerBound: CGFloat = 0.5,
         translateUpperBound: CGFloat = 1.5,
         scale: Bool = false,
         scaleLowerBound: CGFloat = 0.5,
         scaleUpperBound: CGFloat = 1.5,
         rotate: Bool = false,
         rotateLowerBound: CGFloat = 0.5,
         rotateUpperBound: CGFloat = 1.5,
         flip: Bool = false) {
        self.projectData = projectData
        self.subjects = subjects
        self.backgrounds = backgrounds
        self.title = title
        self.population = population
        self.translate = translate
        self.translateLowerBound = translateLowerBound
        self.translateUpperBound = translateUpperBound
        self.scale = scale
        self.scaleLowerBound = scaleLowerBound
        self.scaleUpperBound = scaleUpperBound
        self.rotate = rotate
        self.rotateLowerBound = rotateLowerBound
        self.rotateUpperBound = rotateUpperBound
        self.flip = flip
    }
    
    func createCollageSet() -> [Collage] {
        var set = [Collage]()
        let modifacations: [Modification] = createModList()
        for x in backgrounds {
            for i in appendableBackgroundSet(x, modificaitions: modifacations) {
                set.append(i)
            }
        }
        return set
    }
    
    func appendableBackgroundSet(_ background: CIImage, modificaitions: [Modification]) -> [Collage] {
        var set = [Collage]()
        for i in modificaitions {
            for x in subjects {
                let modifiedSubject = x.modify(i, size: background.extent.size)
                set.append(creator.create(subject: modifiedSubject, background: background, title: "\(title)"))
            }
        }
        return set
    }
    
    func createModList(incomingMods: [Modification] = [Modification()]) -> [Modification] {
        var mods = incomingMods
        if scale {
            for i in mods {
                var newMod = i
                newMod.scale = CGFloat.random(in: scaleLowerBound..<scaleUpperBound)
                mods.append(newMod)
            }
        }
        if rotate {
            for i in mods {
                var newMod = i
                newMod.rotate = CGFloat.random(in: (rotateLowerBound * 2 * .pi)..<(rotateUpperBound * 2 * .pi))
                mods.append(newMod)
            }
        }
        if flip {
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
        if translate {
            for i in mods {
                var newMod = i
                newMod.translateX = CGFloat.random(in: translateLowerBound..<translateUpperBound)
                mods.append(newMod)
                newMod.translateY = CGFloat.random(in: translateLowerBound..<translateUpperBound)
                mods.append(newMod)
                newMod.translateX = CGFloat.random(in: translateLowerBound..<translateUpperBound)
                mods.append(newMod)
            }
        }
        return mods
    }
    
    func createRandModList() -> [Modification] {
        var mods: [Modification]
        
        return mods
    }
    
    func createJSON() throws -> String  { //return type may be wrong
        projectData = createCollageSet()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
        var annotationArray = [CollageData]()
        var count = 0
        for i in projectData {
            i.data.imagefilename = "\(count).png"
            annotationArray.append(i.data)
            count += 1
        }
        let output = try encoder.encode(annotationArray)
        return String.init(data: output, encoding: .utf8)!
    }
}

struct Modification {
    var translateX: CGFloat = 0
    var translateY: CGFloat = 0
    var scale: CGFloat = 1.0
    var rotate: CGFloat = 0.0
    var flipX: Bool = false
    var flipY: Bool = false
}

func degreesToRadians(_ degrees: CGFloat) -> CGFloat{
    return degrees * .pi / 180.0
}
