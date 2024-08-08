//
//  AdaptiveImage.swift
//  MLCollage
//
//  Created by Robert Bates on 8/8/24.
//

import Foundation
import SwiftUI

struct AdaptiveImage<Element> {
    var image: Element { createImage() }
    
    func createImage() {
#if os(macOS)
        
#else
        
#endif
    }
}

//CIImage for manipulation
//UIImage for ios
//NSImage for mac
