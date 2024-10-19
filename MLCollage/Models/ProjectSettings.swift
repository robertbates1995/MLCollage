//
//  ProjectSettings.swift
//  MLCollage
//
//  Created by Robert Bates on 9/5/24.
//

import Foundation

struct ProjectSettings: Equatable, Codable {
    var population: Double
    var numberOfEachSubject: Double
    var translate: Bool
    var translateLowerBound: Double
    var translateUpperBound: Double
    var scale: Bool
    var scaleLowerBound: Double
    var scaleUpperBound: Double
    var rotate: Bool
    var rotateLowerBound: Double
    var rotateUpperBound: Double
    var flip: Bool
    
    init(population: Double = 10.0,
         numberOfEachSubject: Double = 1.0,
         translate: Bool = true,
         translateLowerBound: Double = 0.0,
         translateUpperBound: Double = 1.0,
         scale: Bool = true,
         scaleLowerBound: Double = 0.5,
         scaleUpperBound: Double = 1.5,
         rotate: Bool = true,
         rotateLowerBound: Double = 0.0,
         rotateUpperBound: Double = 0.5,
         flip: Bool = true) {
        self.population = population
        self.numberOfEachSubject = numberOfEachSubject
        self.translate = translate
        self.translateLowerBound = translateLowerBound
        self.translateUpperBound = translateUpperBound
        self.scale = scale
        self.scaleLowerBound = scaleLowerBound
        self.scaleUpperBound = scaleUpperBound
        self.rotate = rotate
        self.rotateLowerBound = rotateLowerBound
        self.rotateUpperBound = rotateUpperBound
        self.flip = flip
    }
}
