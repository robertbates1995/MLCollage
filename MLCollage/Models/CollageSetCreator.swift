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
    var background: CIImage
    var title: String
    var numberOfSubjects: Int
    let creator = CollageCreator()

    init(subject: CIImage, background: CIImage, title: String, numberOfSubjects: Int) {
        self.subject = subject
        self.background = background
        self.title = title
        self.numberOfSubjects = numberOfSubjects
    }
    
    func createCollageSet(population: Int, translateX: CGFloat, translateY: CGFloat) -> [Collage] {
        var set = [Collage]()
        for i in 0...population {
            set.append(creator.create(subject: subject, background: background, title: title, numberOfSubjects: numberOfSubjects))
            if translateX > 0 || translateY > 0 {
                subject.transformed(by: .init(translationX: translateX, y: translateY))
            }
        }
        return set
    }
}
