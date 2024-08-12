//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

class CollageSetCreator {
    var subject = CIImage.black
    var subjectLabel = "Subject Label"
    var background = CIImage.black
    var title = "Title"
    var numberOfSubjects = 0
    
    init(subject: CIImage = CIImage.black, subjectLabel: String = "Subject Label", background: CIImage = CIImage.black, title: String = "Title", numberOfSubjects: Int = 0) {
        self.subject = subject
        self.subjectLabel = subjectLabel
        self.background = background
        self.title = title
        self.numberOfSubjects = numberOfSubjects
    }
    
    func createCollageSet(population: Int, translateX: CGFloat = 0, translateY: CGFloat = 0, scaleChangeX: CGFloat = 0, scaleChangeY: CGFloat = 0) -> [Collage] {
        var set = [Collage]()
        let creator = CollageCreator()
        
        for i in 0...population {
            set.append(creator.create(subjects: [(subject, subjectLabel)], background: background, title: "\(title)_\(i)"))
            if translateX > 0 || translateY > 0 {
                subject = subject.transformed(by: .init(translationX: translateX, y: translateY))
            }
            if scaleChangeX > 0 || scaleChangeY > 0 {
                subject = subject.transformed(by: .init(scaleX: scaleChangeX, y: scaleChangeY))
            }
        }
        
        return set
    }
}
