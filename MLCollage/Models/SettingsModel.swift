//
//  ProjectSettings.swift
//  MLCollage
//
//  Created by Robert Bates on 9/5/24.
//

import Foundation

struct SettingsModel: Equatable, Codable {
    var numberOfEachSubject: Double
    var translate: Bool
    var scale: Bool
    var rotate: Bool
    var flipHorizontal: Bool
    var flipVertical: Bool
    var outputSize: CGFloat
    
    init(numberOfEachSubject: Double = 1.0,
         translate: Bool = true,
         scale: Bool = true,
         rotate: Bool = true,
         flipHorizontal: Bool = true,
         flipVertical: Bool = true,
         outputSize: CGFloat = 299) {
        self.numberOfEachSubject = numberOfEachSubject
        self.translate = translate
        self.scale = scale
        self.rotate = rotate
        self.flipHorizontal = flipHorizontal
        self.flipVertical = flipVertical
        self.outputSize = outputSize
    }
}
