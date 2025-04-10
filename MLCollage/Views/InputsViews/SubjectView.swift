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
    @Binding var images: [MLCImage]
    let editing: Bool
    @State var selectedUUID: Set<String> = []

    var body: some View {
        ScrollView {
            if images.isEmpty {
                Image(systemName: "photo")
                    .foregroundColor(.white)
                    .padding()
                    .background(Circle().fill(Color.secondary))
                Text("add images")
            } else {
                VStack {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 80))],
                        spacing: 20
                    ) {
                        ForEach(images, id: \.self) { image in
                            if !editing {
                                NavigationLink(destination: subjectImage(image))
                                {
                                    subjectImage(image)
                                }
                            } else {
                                Button(
                                    action: {
                                        if selectedUUID.contains(
                                            image.id
                                        ) {
                                            selectedUUID.remove(
                                                image.id
                                            )
                                        } else {
                                            selectedUUID.insert(
                                                image.id
                                            )
                                        }
                                    },
                                    label: {
                                        if selectedUUID.contains(image.id) {
                                            selectedImage(image: image)
                                        } else {
                                            unSelectedImage(image: image)
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(10)
                }
            }
        }
    }

    fileprivate func subjectImage(_ image: MLCImage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.uiImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
        }
    }

    func unSelectedImage(image: MLCImage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.uiImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            Image(systemName: "circle")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white)
                .padding(7)
        }
    }

    func selectedImage(image: MLCImage) -> some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image.uiImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center
                )
                .border(.blue, width: 3)
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, .blue)
                .padding(7)
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    NavigationView {
        SubjectView(images: $model, editing: false)
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    NavigationView {
        SubjectView(images: $model, editing: true)
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    NavigationView {
        SubjectView(images: $model, editing: true)
    }
}
