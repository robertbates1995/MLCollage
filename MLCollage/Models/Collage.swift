//
//  ImageCreator.swift
//  MLCollage
//
//  Created by Robert Bates on 7/16/24.
//

import CoreImage
import Foundation
import UIKit

//#if os(macOS)
//import AppKit
//typealias ImageType = NSImage
//#else
//import UIKit
//import SwiftUI
//typealias ImageType = UIImage
//#endif

class Collage: Identifiable {
    let id = UUID()
    var image: UIImage
    var json: CreateMLFormat

    init(image: UIImage, json: CreateMLFormat) {
        self.image = image
        self.json = json
    }
}

extension Array where Element == Collage {
    var json: Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .init(arrayLiteral: [
            .prettyPrinted, .sortedKeys,
        ])
        let output = try! encoder.encode(self.map(\.json))
        return output
    }
}

