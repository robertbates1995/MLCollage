//
//  SubjectData.swift
//  MLCollage
//
//  Created by Robert Bates on 7/26/24.
//

import Foundation

struct SubjectData {
    var label: String = ""
    var x: Double = 0
    var y: Double = 0
    var width: Double = 0 //should be calculated based off image
    var height: Double = 0 //should be calculated based off image
    
    init(label: String) {
        self.label = label
    }
    
   
}
