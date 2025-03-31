//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import SwiftUI
import PhotosUI

struct EditSubjectView: View {
    @Binding var subject: Subject
    @State private var isDeleting = false
    @Environment(\.dismiss) var dismiss

    private static let initialColumns = 3
    @State private var numColumns = initialColumns
    @State private var gridColumns = Array(
        repeating: GridItem(.flexible()), count: initialColumns)

    @State private var photosPickerItems: [PhotosPickerItem] = []

    func addImage(_ image: UIImage) {
        subject.images.append(MLCImage(uiImage: image))
    }

    var body: some View {
        VStack {
            HStack {
                Text("Label: ")
                TextField("new subject", text: $subject.label)
                    .padding()
                    .background(Color.black.opacity(0.1))
            }
            SubjectView(
                images: $subject.images, isClickable: true,
                isDeleting: isDeleting
            )
        }
        .padding()
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
            ToolbarItem(placement: .navigationBarLeading) {
                Button(isDeleting ? "Done" : "Edit") {
                    withAnimation { isDeleting.toggle() }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                PhotosPicker( selection: $photosPickerItems,
                              maxSelectionCount: 10, selectionBehavior: .ordered) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("save") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var model = Subject(label: "", images: [.apple1, .apple2])
    NavigationView {
        EditSubjectView(subject: $model)
    }
}
