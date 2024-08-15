//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

class Project {
    var projectData = [Collage]()
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
    
    func createCollageSet(modificaitions: Modifications) -> [Collage] {
        var set = [Collage]()
        let creator = CollageCreator()
        //create all permutations for every background
        for x in backgrounds {
            for i in appendableBackgroundSet(x, modificaitions: modificaitions) {
                set.append(i)
            }
        }
        return set
    }
    
    func appendableBackgroundSet(_ background: CIImage, modificaitions: Modifications) -> [Collage] {
        var set = [Collage]()
        var changableSubject = subject.image
        for i in 0...modificaitions.population {
            set.append(creator.create(subject: subject, background: background, title: "\(title)"))
            if modificaitions.translateX > 0 || modificaitions.translateY > 0 {
                changableSubject = changableSubject.transformed(by: .init(translationX: modificaitions.translateX, y: modificaitions.translateY))
            }
            if modificaitions.scaleChangeX > 0 || modificaitions.scaleChangeY > 0 {
                changableSubject = changableSubject.transformed(by: .init(scaleX: modificaitions.scaleChangeX, y: modificaitions.scaleChangeY))
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

class Modifications {
    var population: Int = 0
    var translateX: CGFloat = 0
    var translateY: CGFloat = 0
    var scaleChangeX: CGFloat = 0
    var scaleChangeY: CGFloat = 0
}
