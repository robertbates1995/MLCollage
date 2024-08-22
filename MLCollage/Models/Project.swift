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
    var iterations: Int
    let creator = CollageCreator()
    
    
    init(projectData: [Collage] = [], subjects: [Subject] = [], backgrounds: [CIImage] = [], title: String = "project title", translate: Bool = false, scale: Bool = false, rotate: Bool = false, iterations: Int = 1) {
        self.projectData = projectData
        self.subjects = subjects
        self.backgrounds = backgrounds
        self.title = title
        self.translate = translate
        self.scale = scale
        self.rotate = rotate
        self.iterations = iterations
    }
    
    func createCollageSet() -> [Collage] {
        var set = [Collage]()
        let modifacations: [Modification] = createModList()
        let creator = CollageCreator()
        //create all permutations for every background
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
        print("scale: \(scale), translate: \(translate), rotate: \(rotate)")
        var mods = incomingMods
        if scale {
            for i in incomingMods {
                var temp = i
                temp.scale = 2.0 //critical value
                mods.append(temp)
            }
        }
        if rotate {
            for i in incomingMods {
                mods.append(Modification(rotate: 90.0)) //critical value
            }
        }
        //translate should be applied last
        if translate {
            for i in incomingMods {
                mods.append(Modification(translateX: 1.0)) //critical value
                mods.append(Modification(translateY: 1.0)) //critical value
                mods.append(Modification(translateX: 1.0, translateY: 1.0)) //critical value
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
    //var mirrorX: Bool = false
    //var mirrorY: Bool = false
    //var blur: CGFloat = 0.0
}
