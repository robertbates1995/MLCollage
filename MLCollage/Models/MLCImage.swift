//
//  MLCImage.swift
//  MLCollage
//
//  Created by Robert Bates on 11/2/24.
//

import UIKit

struct MLCImage: Identifiable {
    //id should be the file name
    var id: String = ""
    var uiImage: UIImage
    var cgImage: CGImage
    //nsImage: NSImage (use for macOS)
}
