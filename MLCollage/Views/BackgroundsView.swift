//
//  BackgroundsView.swift
//  MLCollage
//
//  Created by Robert Bates on 3/24/25.
//

import PhotosUI
import SwiftUI

struct BackgroundsView: View {
    @Binding var model: InputModel
    @State var addNewBackground: Bool = false
    @State var editing: Bool = false
    @State var selectedUUID: Set<String> = []
    @State var showConfirmation = false
    @State private var photosPickerItems: [PhotosPickerItem] = []

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 10
                    ) {
                        ForEach(model.backgrounds) { image in
                            if editing {
                                Button(
                                    action: {
                                        if editing {
                                            if selectedUUID.contains(image.id) {
                                                selectedUUID.remove(image.id)
                                            } else {
                                                selectedUUID.insert(image.id)
                                            }
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
                            } else {
                                regularImage(image: image)
                            }
                        }
                    }
                }
            }
            .onChange(of: photosPickerItems) { _, _ in
                let localPhotosPickerItems = photosPickerItems
                photosPickerItems.removeAll()
                Task {
                    for item in localPhotosPickerItems {
                        if let data = try? await item.loadTransferable(
                            type: Data.self
                        ) {
                            if let image = UIImage(data: data) {
                                addImage(image)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(
                        action: {
                            if editing {
                                selectedUUID.removeAll()
                                editing.toggle()
                            } else {
                                editing.toggle()
                            }
                        },
                        label: {
                            if editing {
                                Text("Done")
                            } else {
                                Text("Edit")
                            }
                        }
                    )
                    .confirmationDialog(
                        "Are you sure?",
                        isPresented: $showConfirmation
                    ) {
                        Button("Remove Selected") {
                            model.clearBackgrounds(idArray: Array(selectedUUID))
                            editing.toggle()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Delete selected elements?")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if editing {
                        Button(
                            action: {
                                if selectedUUID.count > 0 {
                                    showConfirmation.toggle()
                                }
                            },
                            label: {
                                Image(systemName: "trash")
                            }
                        )
                    } else {
                        PhotosPicker(
                            "add",
                            selection: $photosPickerItems,
                            maxSelectionCount: 10,
                            selectionBehavior: .ordered
                        )
                    }

                }
            }
            .sheet(
                isPresented: $addNewBackground
            ) {
                NavigationView {
                    EditBackgroundView(backgrounds: $model.backgrounds)
                }
            }
            .navigationTitle("Backgrounds")
            .foregroundColor(.accent)
        }
    }

    func addImage(_ image: UIImage) {
        model.backgrounds.append(MLCImage(uiImage: image))
    }

    func regularImage(image: MLCImage) -> some View {
        ZStack {
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
                .aspectRatio(1 / 1, contentMode: .fit)
                .clipped()
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
        ZStack {
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
                .aspectRatio(1 / 1, contentMode: .fit)
                .clipped()
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "circle")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white)
                        .padding()
                }
            }
        }
    }

    func selectedImage(image: MLCImage) -> some View {
        ZStack {
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
                .aspectRatio(1 / 1, contentMode: .fit)
                .border(.blue, width: 3)
                .clipped()
                .mask {
                    RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    )
                }
                .padding(5.0)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .blue)
                        .padding()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    BackgroundsView(model: $model)
}

#Preview {
    @Previewable @State var model = InputModel()
    BackgroundsView(model: $model)
}
