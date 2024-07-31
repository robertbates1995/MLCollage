//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import Foundation
import UIKit
import SwiftUI

@Observable
class CollageCreator {
    func create(subject: CIImage, background: CIImage, title: String, numberOfSubjects: Int) -> Collage {
        //will likely need parameters to control number of subjects and their orientations
        //create one annotation and one Collage in this step
        var image = subject.composited(over: background)
        var subjectData = [CollageData.SubjectData(label: title)]
        var loops = 0
        while loops < numberOfSubjects - 1 {
            //change subject data
            //paste subject with new values
            subject.composited(over: background)
            //add new values to collageData
            subjectData.append(CollageData.SubjectData(label: title))
            loops += 1
        }
        let data = CollageData(annotations: subjectData, image: title)
        return Collage(image: UIImage(ciImage: image), data: data)
    }
}

class Collage {
    var image: UIImage
    var data: CollageData
    
    init(image: UIImage, data: CollageData) {
        self.image = image
        self.data = data
    }
}
