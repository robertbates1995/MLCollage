//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct EditSubjectView: View {
    @Binding var subject: Subject
    @State var photosPickerItems: [PhotosPickerItem] = []
    
    func addImage(_ image: UIImage) {
        subject.images.append(image)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Label: ")
                TextField("new subject", text: $subject.label)
                    .padding()
                    .background(Color.black.opacity(0.1))
            }
            HStack {
                PhotosPicker(
                    "add photos", selection: $photosPickerItems,
                    maxSelectionCount: 10, selectionBehavior: .ordered)
                Spacer()
            }
            SubjectView(images: $subject.images)
            Spacer()
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
    }
}

#Preview {
    @Previewable @State var model = Subject(label: "")
    EditSubjectView(subject: $model)
}
