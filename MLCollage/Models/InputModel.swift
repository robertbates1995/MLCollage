//
//  InputModel.swift
//  MLCollage
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI

@Observable
class InputModel {
    var subjects: [String: InputSubject]
    var backgrounds: [UIImage]
    var newSubject: InputSubject {
        var temp = InputSubject(label: "New Subject")
        var counter = 2
        while subjects.keys.contains(temp.label) {
            temp = InputSubject(label: "New Subject \(counter)")
            counter += 1
        }
        return temp
    }
    
    init(subjects: [String : InputSubject], backgrounds: [UIImage]) {
        self.subjects = subjects
        self.backgrounds = backgrounds
    }
    
    func add(image: UIImage, label: String) {
        var subject = subjects[label] ?? InputSubject(label: label, images: [])
        subject.images.append(image)
        subjects[label] = subject
    }
    
    func add(background: UIImage) {
        backgrounds.append(background)
    }
    
    func add(subject: InputSubject) {
        var temp = subject.label
        var counter = 2
        while subjects.keys.contains(temp) {
            temp = "\(subject.label) \(counter)"
            counter += 1
        }
        subjects[temp] = InputSubject(label: temp, images: subject.images)
    }
}

extension InputModel {
    static let mock = InputModel(subjects: ["apple": .init(label: "apple", images: [.apple1]),
                                            "bannana": .init(label: "bannana", images: [.banana1]),
                                            "pepper": .init(label: "pepper", images: [.pepper1])],
                                 backgrounds: [.crazyBackground1, .crazyBackground2, .crazyBackground3])
}