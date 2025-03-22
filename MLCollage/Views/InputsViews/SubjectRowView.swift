//
//  SubjectView 2.swift
//  MLCollage
//
//  Created by Robert Bates on 3/22/25.
//

//
//  ContentView.swift
//  suygfshiudrhiu
//
//  Created by Robert Bates on 10/30/24.
//

import PhotosUI
import SwiftUI
import UIKit

struct SubjectRowView: View {
    @Binding var images: [MLCImage]
    let size: CGFloat

    var body: some View {
        ScrollView {
            VStack {
                Spacer()
            if images.isEmpty {
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                        .padding()
                        .background(Circle().fill(Color.secondary))
                    Text("add images")
                    Spacer()
                }
            } else {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: size))], spacing: 20
                    ) {
                        ForEach(images, id: \.self) { image in
                            subjectImage(image)
                        }
                    }
                }
            }
        }
    }

    fileprivate func subjectImage(_ image: MLCImage) -> some View {
        Image(uiImage: image.uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .background(.black.opacity(0.3))
            .cornerRadius(size/10)
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    NavigationView {
        SubjectRowView(images: $model, size: 100.0)
    }
}
