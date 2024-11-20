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
    var scaleLowerBound: Double
    var scaleUpperBound: Double
    var rotate: Bool
    var rotateLowerBound: Double
    var rotateUpperBound: Double
    var flipHorizontal: Bool
    var flipVertical: Bool
    
    init(numberOfEachSubject: Double = 1.0,
         translate: Bool = true,
         translateLowerBound: Double = 0.0,
         translateUpperBound: Double = 1.0,
         scale: Bool = true,
         scaleLowerBound: Double = 0.5,
         scaleUpperBound: Double = 1.5,
         rotate: Bool = true,
         rotateLowerBound: Double = 0.0,
         rotateUpperBound: Double = 0.5,
         flipHorizontal: Bool = true,
         flipVertical: Bool = true) {
        self.numberOfEachSubject = numberOfEachSubject
        self.translate = translate
        self.scale = scale
        self.scaleLowerBound = scaleLowerBound
        self.scaleUpperBound = scaleUpperBound
        self.rotate = rotate
        self.rotateLowerBound = rotateLowerBound
        self.rotateUpperBound = rotateUpperBound
        self.flipHorizontal = flipHorizontal
        self.flipVertical = flipVertical
    }
}
