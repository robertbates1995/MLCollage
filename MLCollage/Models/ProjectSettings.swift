//
//  ProjectSettings.swift
//  MLCollage
//
//  Created by Robert Bates on 9/5/24.
//

import Foundation

struct ProjectSettings {
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
    
    init(population: Int = 1,
         numberOfEachSubject: Int = 1,
         translate: Bool = false,
         translateLowerBound: CGFloat = 0.5,
         translateUpperBound: CGFloat = 1.5,
         scale: Bool = false,
         scaleLowerBound: CGFloat = 0.5,
         scaleUpperBound: CGFloat = 1.5,
         rotate: Bool = false,
         rotateLowerBound: CGFloat = 0.5,
         rotateUpperBound: CGFloat = 1.5,
         flip: Bool = false) {
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
