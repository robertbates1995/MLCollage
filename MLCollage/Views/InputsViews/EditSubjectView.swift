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
    @State private var isEditing = false
    
    private static let initialColumns = 3
    @State private var numColumns = initialColumns
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)

    @State private var photosPickerItems: [PhotosPickerItem] = []
    
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
            SubjectView(images: $subject.images)
            Spacer()
            HStack() {
                Spacer()
                PhotosPicker(
                    "add photos", selection: $photosPickerItems,
                    maxSelectionCount: 10, selectionBehavior: .ordered)
                Spacer()
            }
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

struct SubjectView: View {
    @Binding var images: [UIImage]

    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 20)
                {
                    ForEach(images, id: \.self) { image in
                        subjectImage(image)
                    }
                }
            }
        }
    }
    
    fileprivate func subjectImage(_ image: UIImage) -> some View {
        return Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(5.0)
    }
}

#Preview {
    @Previewable @State var model = Subject(label: "")
    EditSubjectView(subject: $model)
}
