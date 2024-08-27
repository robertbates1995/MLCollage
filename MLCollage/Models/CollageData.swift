//
//  SubjectData.swift
//  MLCollage
//
//  Created by Robert Bates on 7/26/24.
//

import Foundation

struct CollageData: Codable, Equatable {
    var annotation: [Annotation]
    var imagefilename: String
    
    init(annotation: [Annotation], title image: String) {
        self.annotation = annotation
        self.imagefilename = image
    }
    
    struct Annotation: Codable, Equatable {
        //this is the same label from the class Subject
        var label: String = ""
        //this is where the subject is in the collage
        var coordinates = Coordinates()
        
        init(label: String, coordinates: CollageData.Annotation.Coordinates = Coordinates()) {
            self.label = label
            self.coordinates = coordinates
        }
        
        struct Coordinates: Codable, Equatable {
            var x: Double = 0
            var y: Double = 0
            var width: Double = 0 //should be calculated based off image
            var height: Double = 0 //should be calculated based off image
        }
    }
}

extension CollageData.Annotation.Coordinates {
    init(_ extent: CGRect) {
        x = extent.midX
        y = extent.midY
        width = extent.width
        height = extent.height
    }
}
