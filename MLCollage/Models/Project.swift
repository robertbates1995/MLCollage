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
    let creator = CollageCreator()
    
    
    init(projectData: [Collage] = [], subjects: [Subject] = [], backgrounds: [CIImage] = [], title: String = "project title", translate: Bool = false, scale: Bool = false) {
        self.projectData = projectData
        self.subjects = subjects
        self.backgrounds = backgrounds
        self.title = title
        self.translate = translate
        self.scale = scale
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
    
    func createModList() -> [Modification] {
        var mods = [Modification()]
        if translate {
            mods.append(Modification(translateX: 1.0))
            mods.append(Modification(translateY: 1.0))
            mods.append(Modification(translateX: 1.0, translateY: 1.0))
            //create mod
            //pass on to do next mod
        }
        if scale {
            for i in mods {
                var temp = i
                temp.scaleChange = 2.0
                mods.append(temp)
            }
        }
        //create all permutations of modificaton
        return mods
    }
}

struct Modification {
    var translateX: CGFloat = 0
    var translateY: CGFloat = 0
    var scaleChange: CGFloat = 1.0
}
