//
//  CollageFactory.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import UIKit
import CoreImage

struct CollageFactory {
    let mod: Modification
    let subject: UIImage
    let background: UIImage
    let label: String
    let fileName: String
    
    //create one annotation and returns one Collage
    func create() -> Collage {
        let background = background.toCIImage()
        var subject = subject.toCIImage()

        rotate(&subject)
        
        scale(&subject)
        
        flip(&subject)
        
        translate(background, &subject)
        
        let collage = subject.composited(over: background).cropped(to: background.extent)
        let annotation = Annotation(label: label, coordinates: .init(subject.extent, backgroundHeight: collage.extent.height))
        return Collage(image: collage.toUIImage(), json: .init(annotation: [annotation], imagefilename: fileName))
    }
    
    
    private func rotate(_ subject: inout CIImage) {
        var subjectSize = subject.extent
        subject = subject.transformed(by: .init(translationX: -subjectSize.width / 2, y: -subjectSize.height / 2))
        subjectSize = subject.extent
        subject = subject.transformed(by: .init(rotationAngle: mod.rotate))
        subjectSize = subject.extent
        subject = subject.transformed(by: .init(translationX: subjectSize.width / 2, y: subjectSize.height / 2))
    }
    
    private func flip(_ subject: inout CIImage) {
        if mod.flipY {
            subject = subject.oriented(.downMirrored)
        }
        if mod.flipX {
            subject = subject.oriented(.upMirrored)
        }
    }
    
    private func scale(_ subject: inout CIImage) {
        subject = subject.transformed(by: .init(scaleX: mod.scale, y: mod.scale))
    }
    
    private func translate(_ background: CIImage, _ subject: inout CIImage) {
        let subjectSize = subject.extent
        let backgroundSize = background.extent
        subject = subject.transformed(by: .init(translationX: mod.translateX * (backgroundSize.width - subjectSize.width), y: mod.translateY * (backgroundSize.height - subjectSize.height)))
    }
}
