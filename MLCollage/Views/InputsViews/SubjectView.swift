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
    @State var photosPickerItems: [PhotosPickerItem] = []
    @State private var isDragging = false

    @Binding var images: [UIImage]

    func addImage(_ image: UIImage) {
        images.append(image)
    }

    var body: some View {

        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 20)
            {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color.gray.opacity(0.5))
                        .cornerRadius(5.0)
                        .onLongPressGesture {
                            isDragging = true
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    offset = gesture.translation
                                }
                                .onEnded { _ in
                                    isDragging = false
                                }
                                .isEnabled(isDragging)  // Only active during dragging
                        )
                }
                .onMove { images.move(fromOffsets: $0, toOffset: $1) }
            }
            HStack {
                PhotosPicker(
                    "add photos", selection: $photosPickerItems,
                    maxSelectionCount: 10, selectionBehavior: .ordered)
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
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    SubjectView(images: $model)
}
