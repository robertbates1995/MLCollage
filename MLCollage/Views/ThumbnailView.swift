//
//  ThumbnailView.swift
//  MLCollage
//
//  Created by Robert Bates on 1/10/25.
//

import SwiftUI

struct ThumbnailView: View {
    let collage: Collage
    @State var cache: UIImage?
    var thumbnail: UIImage {
        if let cache {
            return cache
        } else {
            let temp = collage.image
            //scale temp
            cache = temp
            return temp
        }
    }

    var body: some View {
        Image(uiImage: thumbnail)
    }
}
