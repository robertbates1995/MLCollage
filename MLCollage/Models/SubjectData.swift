//
//  SubjectData.swift
//  MLCollage
//
//  Created by Robert Bates on 7/26/24.
//

import Foundation

struct SubjectData {
    var label: String = ""
    var coordinates: Coordinates
    
    init(label: String, coordinates: Coordinates) {
        self.label = label
        self.coordinates = coordinates
    }
    
    class Coordinates {
        var x: Double = 0
        var y: Double = 0
        var width: Double = 0 //should be calculated based off image
        var height: Double = 0 //should be calculated based off image
    }
}
