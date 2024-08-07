//
//  ImageSet.swift
//  MLCollage
//
//  Created by Robert Bates on 7/31/24.
//

import Foundation
import UIKit

class CollageSetCreator {
    var subject: CIImage
    var subjectLabel: String
    var background: CIImage
    var title: String
    var numberOfSubjects: Int
    let creator = CollageCreator()

    init(subject: CIImage, subjectLabel: String, background: CIImage, title: String, numberOfSubjects: Int) {
        self.subject = subject
        self.subjectLabel = subjectLabel
        self.background = background
        self.title = title
        self.numberOfSubjects = numberOfSubjects
    }
    
    func createCollageSet(population: Int, translateX: CGFloat, translateY: CGFloat, scaleChangeX: CGFloat, scaleChangeY: CGFloat) -> [Collage] {
        var set = [Collage]()
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
