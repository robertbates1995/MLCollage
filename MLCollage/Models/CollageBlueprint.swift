//
//  CollageFactory.swift
//  MLCollage
//
//  Created by Robert Bates on 11/8/24.
//

import CoreImage
import UIKit

struct CollageBlueprint {
    let mod: Modification
    let subjectImage: UIImage
    let background: UIImage
    let label: String
    let fileName: String

    func create(size: CGFloat? = nil) -> Collage {

        let background = scaleBackground(size: size)

        var subject = subjectImage.toCIImage()

        scaleToBackground(background, &subject)

        rotate(&subject)

        scale(&subject)

        flip(&subject)

        translate(background, &subject)
        
        let scanner = Scanner()
        let trimmedExtent = scanner.findSubjectSize(image: subject.toUIImage()).offsetBy(dx: subject.extent.origin.x,
                                                                                         dy: subject.extent.origin.y)
        let collage = subject.composited(over: background).cropped(
            to: background.extent)
        let annotation = Annotation(
            label: label,
            coordinates: .init(
                trimmedExtent, backgroundHeight: collage.extent.height))
        return Collage(
            image: collage.toUIImage(),
            json: .init(annotation: [annotation], imagefilename: fileName))
    }

    private func rotate(_ subject: inout CIImage) {
        let subjectSize = subject.extent
        let center: CGPoint = .init(
            x: subjectSize.width / 2, y: subjectSize.height / 2)

        subject = subject.transformed(
            by: .init(translationX: -center.x, y: -center.y))
        subject = subject.transformed(
            by: .init(rotationAngle: mod.rotate * .pi))
        subject = subject.transformed(
            by: .init(translationX: center.x, y: center.y))
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
        subject = subject.transformed(
            by: .init(scaleX: mod.scale, y: mod.scale))
    }

    private func translate(_ background: CIImage, _ subject: inout CIImage) {
        let subjectSize = subject.extent
        let backgroundSize = background.extent
        subject = subject.transformed(
            by: .init(
                translationX: mod.translateX
                    * (backgroundSize.width - subjectSize.width),
                y: mod.translateY * (backgroundSize.height - subjectSize.height)
            ))
    }

    private func scaleToBackground(
        _ background: CIImage, _ subject: inout CIImage
    ) {
        let heightRatio = background.extent.height / subject.extent.height
        let widthRatio = background.extent.width / subject.extent.width

        let ratio = min(heightRatio, widthRatio)

        subject = subject.transformed(by: .init(scaleX: ratio, y: ratio))
    }

    private func scaleBackground(size: CGFloat?) -> CIImage {
        var image = background.toCIImage()
        guard let size else {
            return image
        }
        let yRatio = size / image.extent.height
        let xRatio = size / image.extent.width

        let ratio = max(xRatio, yRatio)

        image = image.transformed(by: .init(scaleX: ratio, y: ratio))
        image = image.transformed(by: .init(
            translationX: -(image.extent.width - size) / 2,
            y: -(image.extent.height - size) / 2
        ))

        return image.cropped(
            to: CGRect(
                x: 0,
                y: 0, width: size, height: size)
        )
    }
}
