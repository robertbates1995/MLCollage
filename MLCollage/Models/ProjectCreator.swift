//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

class ProjectCreator {
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
        for x in backgrounds {
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
