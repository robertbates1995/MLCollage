//
//  ContentView.swift
//  suygfshiudrhiu
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI
import UIKit
import PhotosUI

struct InputSubject {
    let label: String
    var images: [UIImage]
    
    init(label: String, images: [UIImage]) {
        self.label = label
        self.images = images
    }
}



struct SubjectView: View {
    let label: String
    @State var images: [UIImage] = []
    @State var photosPickerItems: [PhotosPickerItem] = []
    let action: (UIImage) -> ()
    
    var body: some View {
        VStack {
            Text(label)
            HStack {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .padding()
                        .aspectRatio(contentMode: .fill)
                        .background(Color(.gray.withAlphaComponent(0.2)))
                        .clipShape(.rect(cornerRadius: 10))
                        .padding(3)
                }
                HStack {
                    PhotosPicker("select photos", selection: $photosPickerItems, maxSelectionCount: 10, selectionBehavior: .ordered)
                }
            }
        }
        .onChange(of: photosPickerItems) { _, _ in
            let localPhotosPickerItems = photosPickerItems
            photosPickerItems.removeAll()
            Task {
                for item in localPhotosPickerItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            //action(UIImage(systemName: "plus")!)
                            images.append(image)
                            print(photosPickerItems.count)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel(subjects: ["apple": InputSubject(label: "apple", images: [UIImage(systemName: "plus")!, UIImage(systemName: "minus")!])], backgrounds: [UIImage(systemName: "house")!])
    AllSubjectsView(model: $model)
}
