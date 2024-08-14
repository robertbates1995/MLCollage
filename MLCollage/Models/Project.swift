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
    var subjects: [Subject]
    var subjectLabel: String
    var backgrounds: [CIImage]
    var title: String
    var numberOfSubjects: Int
    
    init(subjects: [Subject] = [],
         subjectLabel: String = "Subject Label",
         backgrounds: [CIImage] = [],
         title: String = "Title",
         numberOfSubjects: Int = 0) {
        self.subjects = subjects
        self.subjectLabel = subjectLabel
        self.backgrounds = backgrounds
        self.title = title
        self.numberOfSubjects = numberOfSubjects
    }
    
    func createCollageSet(population: Int, translateX: CGFloat = 0, translateY: CGFloat = 0, scaleChangeX: CGFloat = 0, scaleChangeY: CGFloat = 0) -> [Collage] {
        var set = [Collage]()
        let creator = CollageCreator()
        //create all permutations for every background
        for x in backgrounds {
            for i in appendableBackgroundSet(x) {
                set.append(i)
            }
        }
        return set
    }
    
    func appendableBackgroundSet(_ background: CIImage) -> [Subject] {
        var set = [Collage]()
        for i in subjects {
            set.append(creator.create(subjects: i, background: x, title: "\(title)"))
                            if translateX > 0 || translateY > 0 {
                                subjects[i] = subjects.transformed(by: .init(translationX: translateX, y: translateY))
                            }
                            if scaleChangeX > 0 || scaleChangeY > 0 {
                                subjects = subjects.transformed(by: .init(scaleX: scaleChangeX, y: scaleChangeY))
                            }
        }
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
