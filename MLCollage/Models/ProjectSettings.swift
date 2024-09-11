//
//  ProjectSettings.swift
//  MLCollage
//
//  Created by Robert Bates on 9/5/24.
//

import Foundation

struct ProjectSettings: Equatable, Codable {
    var population: Int
    var numberOfEachSubject: Int
    var translate: Bool
    var translateLowerBound: CGFloat
    var translateUpperBound: CGFloat
    var scale: Bool
    var scaleLowerBound: CGFloat
    var scaleUpperBound: CGFloat
    var rotate: Bool
    var rotateLowerBound: CGFloat
    var rotateUpperBound: CGFloat
    var flip: Bool
    
    init(population: Int = 10,
         numberOfEachSubject: Int = 1,
         translate: Bool = true,
         translateLowerBound: CGFloat = 0.5,
         translateUpperBound: CGFloat = 1.0,
         scale: Bool = true,
         scaleLowerBound: CGFloat = 0.5,
         scaleUpperBound: CGFloat = 1.0,
         rotate: Bool = true,
         rotateLowerBound: CGFloat = 0.5,
         rotateUpperBound: CGFloat = 1.0,
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
