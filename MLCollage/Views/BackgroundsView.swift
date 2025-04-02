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
    @State var selecting: Bool = false
    @State var selectedUUID: Set<String> = []
    @State var showConfirmation = false
    @State private var photosPickerItems: [PhotosPickerItem] = []

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .black.opacity(0.05), .black.opacity(0),
                        ]), startPoint: .top, endPoint: .bottom)
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 10
                    ) {
                        ForEach(model.backgrounds) { image in
                            Button(
                                action: {
                                    if selecting {
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
                                })
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
                            type: Data.self)
                        {
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
                            if selecting {
                                selectedUUID.removeAll()
                                selecting.toggle()
                            } else {
                                selecting.toggle()
                            }
                        },
                        label: {
                            if selecting {
                                Text("Done")
                            } else {
                                Text("Select")
                            }
                        }
                    )
                    .confirmationDialog(
                        "Are you sure?", isPresented: $showConfirmation
                    ) {
                        Button("Remove Selected") {
                            model.clearBackgrounds(idArray: Array(selectedUUID))
                            selecting.toggle()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Delete selected elements?")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if selecting {
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
                            "add", selection: $photosPickerItems,
                            maxSelectionCount: 10, selectionBehavior: .ordered)
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
    
    func unSelectedImage(image: MLCImage) -> some View {
        Image(uiImage: image.uiImage)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity, alignment: .center
            )
            .aspectRatio(1 / 1, contentMode: .fit)
            .clipped()
            .mask {
                RoundedRectangle(
                    cornerRadius: 10, style: .continuous)
            }
            .padding(5.0)
    }

    func selectedImage(image: MLCImage) -> some View {
        Image(uiImage: image.uiImage)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                minWidth: 0, maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity, alignment: .center
            )
            .aspectRatio(1 / 1, contentMode: .fit)
            .border(.blue, width: 3)
            .clipped()
            .mask {
                RoundedRectangle(
                    cornerRadius: 10, style: .continuous)
            }
            .padding(5.0)
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    BackgroundsView(model: $model)
}
