//
//  InputModel.swift
//  MLCollage
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI

struct InputModel {
    var subjects: [Subject]
    var backgrounds: [MLCImage]
    var newSubject: Subject {
        var temp = Subject(label: "New Subject")
        var counter = 2
        while subjects.map(\.label).contains(temp.label) {
            temp = Subject(label: "New Subject \(counter)")
            counter += 1
        }
        return temp
    }
    
    init(subjects: [Subject] = [], backgrounds: [MLCImage] = []) {
        self.subjects = subjects
        self.backgrounds = backgrounds
    }
    
    mutating func add(background: MLCImage) {
        backgrounds.append(background)
    }
    
    mutating func add(subject: Subject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
        } else {
            var temp = subject.label
            var counter = 2
            while subjects.map(\.label).contains(temp) {
                temp = "\(subject.label) \(counter)"
                counter += 1
            }
            subjects.append(Subject(label: temp, images: subject.images))
        }
    }
}

extension InputModel {
    static let mock = InputModel(subjects: [.init(label: "apple", images: [.apple1]),
                                            .init(label: "bannana", images: [.banana1]),
                                            .init(label: "pepper", images: [.pepper1])],
                                 backgrounds: [.crazyBackground1, .crazyBackground2, .crazyBackground3].map({MLCImage(uiImage: $0)}))
}
