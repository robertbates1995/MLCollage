//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

class Project {
    var projectData: [Collage]
    var subject: Subject
    var subjectLabel: String
    var backgrounds: [CIImage]
    var title: String
    var numberOfSubjects: Int
    let creator = CollageCreator()
    
    init(subject: Subject,
         subjectLabel: String = "Subject Label",
         backgrounds: [CIImage] = [],
         title: String = "Title",
         numberOfSubjects: Int = 0) {
        self.subject = subject
        self.subjectLabel = subjectLabel
        self.backgrounds = backgrounds
        self.title = title
        self.numberOfSubjects = numberOfSubjects
    }
    
    func createCollageSet(modifacaitions: Modifacations) -> [Collage] {
        var set = [Collage]()
        let creator = CollageCreator()
        //create all permutations for every background
        for x in backgrounds {
            for i in appendableBackgroundSet(x, modifacaitions: modifacaitions) {
                set.append(i)
            }
        }
        return set
    }
    
    func appendableBackgroundSet(_ background: CIImage, modifacaitions: Modifacations) -> [Collage] {
        var set = [Collage]()
        for i in 0...modifacaitions.population {
            set.append(creator.create(subject: subject, background: background, title: "\(title)"))
            if modifacaitions.translateX > 0 || modifacaitions.translateY > 0 {
                subject = subject.transformed(by: .init(translationX: modifacaitions.translateX, y: modifacaitions.translateY))
            }
            if scaleChangeX > 0 || scaleChangeY > 0 {
                subjects = subjects.transformed(by: .init(scaleX: scaleChangeX, y: scaleChangeY))
            }
        }
        return set
    }
}

class Subject {
    var image: CIImage
    var label: String
    init(image: CIImage = CIImage.black, label: String = "subject label") {
        self.image = image
        self.label = label
    }
}

class Modifacations {
    var population: Int = 0
    var translateX: CGFloat = 0
    var translateY: CGFloat = 0
    var scaleChangeX: CGFloat = 0
    var scaleChangeY: CGFloat = 0
}
