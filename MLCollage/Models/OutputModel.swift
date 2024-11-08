//
//  OutputModel.swift
//  MLCollage
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI

@Observable
class OutputModel {
    var projectData: [Collage]
    
    init(projectData: [Collage] = []) {
        self.projectData = projectData
    }
}

extension OutputModel {
    static let mock = OutputModel()
}
