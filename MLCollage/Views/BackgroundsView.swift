//
//  BackgroundsView.swift
//  MLCollage
//
//  Created by Robert Bates on 3/24/25.
//

import Foundation
import SwiftUI

struct BackgroundsView: View {
    @Binding var model: InputModel
    @State var addNewBackground: Bool = false
    @State var selecting: Bool = false
    @State var selectedUUID: Set<String> = []
    @State var showConfirmation = false

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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button (
                        action: {
                            if selecting {
                                selectedUUID.removeAll()
                                selecting.toggle()
                            }
                            else {
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
                        Button("Remove all") {
                            model.clearAll()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This action cannot be undone.")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            if selecting {
                                if selectedUUID.count > 0 {
                                    showConfirmation.toggle()
                                }
                            } else {
                                addNewBackground.toggle()
                            }
                        },
                        label: {
                            if selecting {
                                Image(systemName: "trash")
                            } else {
                                Image(systemName: "plus")
                            }
                        }
                    )
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
        }
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
