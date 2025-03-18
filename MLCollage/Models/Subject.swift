//
//  Subject.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import UIKit
import GRDB

struct Subject: Identifiable {
    var id: String
    var label: String
    var images: [MLCImage]
}

extension Subject {
    init(label: String, images: [MLCImage] = []) {
        id = UUID().uuidString
        self.label = label
        self.images = images
    }
    
    init(label: String, images: [UIImage]) {
        id = UUID().uuidString
        self.label = label
        self.images = images.map({MLCImage(uiImage: $0)})
    }
    
    public static func == (lhs: Subject, rhs: Subject) -> Bool {
        if lhs.id.map(\.asciiValue) != lhs.id.map(\.asciiValue) { return false}
        return true
    }
    
    //static let mock = Subject(label: "mock", images: [.apple2, .apple3, .apple4])
}
