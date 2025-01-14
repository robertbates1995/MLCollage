//
//  ThumbnailView.swift
//  MLCollage
//
//  Created by Robert Bates on 1/10/25.
//

import SwiftUI

@Observable
@MainActor
class ThumbnailCache {
    @ObservationIgnored var cache: UIImage?
    var size: CGFloat = 10.0

    func thumbnail(from source: Collage) -> UIImage {

        if let cache, cache.size.width == size, cache.size.height == size {
            return cache
        }

        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: size, height: size), true, 1.0)
        source.image.draw(
            in: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        defer { UIGraphicsEndImageContext() }
        cache = UIGraphicsGetImageFromCurrentImageContext()

        return cache ?? .errorIcon
    }
}

struct ThumbnailView: View {
    let collage: Collage
    @State var cache = ThumbnailCache()

    var body: some View {
        Image(uiImage: cache.thumbnail(from: collage))
            .resizable()
            .scaledToFill()
            .onGeometryChange(for: CGFloat.self) { proxy in
                proxy.size.width
            } action: { newWidth in
                cache.size = newWidth
            }
    }
}
