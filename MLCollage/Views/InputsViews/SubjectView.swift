//
//  ContentView.swift
//  suygfshiudrhiu
//
//  Created by Robert Bates on 10/30/24.
//

import PhotosUI
import SwiftUI
import UIKit

struct SubjectView: View {
    @Binding var images: [UIImage]
    let isClickable: Bool
    var isDeleting: Bool

    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 50))], spacing: 20
                ) {
                    ForEach(images, id: \.self) { image in
                        if isClickable {
                            NavigationLink(destination: subjectImage(image)) {
                                subjectImage(image)
                            }
                        } else {
                            subjectImage(image)
                        }
                    }
                }
            }
        }
    }

    fileprivate func subjectImage(_ image: UIImage) -> some View {
        ZStack() {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(5.0)
            if isDeleting {
                Button {
                    guard let index = images.firstIndex(of: image) else {
                        return
                    }
                    withAnimation {
                        _ = images.remove(at: index)
                    }
                } label: {
                    VStack {
                        HStack {
                            Image(systemName: "xmark.square.fill")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, Color.red)
                        }
                        Spacer()
                    }
                    Spacer()
                }
                .offset(x: -2.0, y: -2.0)
            }
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    NavigationView {
        SubjectView(images: $model, isClickable: true, isDeleting: false)
    }
}
