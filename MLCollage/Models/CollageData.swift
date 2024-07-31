//
//  SubjectData.swift
//  MLCollage
//
//  Created by Robert Bates on 7/26/24.
//

import Foundation

struct CollageData: Codable {
    var annotations: [SubjectData]
    var image: String
    
    struct SubjectData: Codable {
        var label: String = ""
        var coordinates = Coordinates()
        
        init(label: String) {
            self.label = label
        }
        
        struct Coordinates: Codable {
            var x: Double = 0
            var y: Double = 0
            var width: Double = 0 //should be calculated based off image
            var height: Double = 0 //should be calculated based off image
        }
        
    }
}


