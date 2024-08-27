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
    //create members that represent mod settings toggled on or off
    var projectData: [Collage]
    var subjects: [Subject]
    var backgrounds: [CIImage]
    var title: String
    var translate: Bool
    var scale: Bool
    var rotate: Bool
    var flip: Bool
    var iterations: Int
    let creator = CollageCreator()
    
    func createJSON() throws -> String  { //return type may be wrong
        projectData = createCollageSet()
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [.prettyPrinted, .sortedKeys])
        var annotationArray = [Collage]()
        for i in projectData {
            annotationArray += i.data
        }
        let output = try encoder.encode(annotationArray)
        return String.init(data: output, encoding: .utf8)!
    }
    
    init(projectData: [Collage] = [], subjects: [Subject] = [], backgrounds: [CIImage] = [], title: String = "project title", translate: Bool = false, scale: Bool = false, rotate: Bool = false, flip: Bool = false, iterations: Int = 1) {
        self.projectData = projectData
        self.subjects = subjects
        self.backgrounds = backgrounds
        self.title = title
        self.translate = translate
        self.scale = scale
        self.rotate = rotate
        self.flip = flip
        self.iterations = iterations
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
                newMod.scale = 2.0 //critical value
                mods.append(newMod)
            }
        }
        if rotate {
            for i in mods {
                var newMod = i
                newMod.rotate = .pi
                mods.append(newMod) //critical value
            }
        }
        //translate should be applied last
        if translate {
            for i in mods {
                var newMod = i
                newMod.translateX = 1.0 //critical value
                mods.append(newMod)
                newMod.translateY = 1.0 //critical value
                mods.append(newMod)
                newMod.translateX = 0.0
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
        return mods
    }
}

struct Modification {
    var translateX: CGFloat = 0
    var translateY: CGFloat = 0
    var scale: CGFloat = 1.0
    var rotate: CGFloat = 0.0
    var flipX: Bool = false
    var flipY: Bool = false
    //var blur: CGFloat = 0.0
}

func degreesToRadians(_ degrees: CGFloat) -> CGFloat{
        return degrees * .pi / 180.0
    }
