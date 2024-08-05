//
//  SubjectData.swift
//  MLCollage
//
//  Created by Robert Bates on 7/26/24.
//

import Foundation

struct CollageData: Codable, Equatable {
    var annotations: [Annotation]
    var image: String
    
    init(annotations: [Annotation], title image: String) {
        self.annotations = annotations
        self.image = image
    }
    
    struct Annotation: Codable, Equatable {
        var label: String = ""
        var coordinates = Coordinates()
        
        init(label: String) {
            self.label = label
        }
        
        struct Coordinates: Codable, Equatable {
            var x: Double = 0
            var y: Double = 0
            var width: Double = 0 //should be calculated based off image
            var height: Double = 0 //should be calculated based off image
        }
    }
}


