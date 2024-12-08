//
//  EditBackgroundView.swift
//  MLCollage
//
//  Created by Robert Bates on 12/8/24.
//

import UIKit
import SwiftUI
import PhotosUI

struct EditBackgroundView: View {
    @Binding var backgrounds: [UIImage]
    @State var photosPickerItems: [PhotosPickerItem] = []
    
    func addImage(_ image: UIImage) {
        backgrounds.append(image)
    }
    
    var body: some View {
        VStack {
            HStack {
                PhotosPicker(
                    "add backgrounds", selection: $photosPickerItems,
                    maxSelectionCount: 10, selectionBehavior: .ordered)
                Spacer()
            }
            SubjectView(images: $backgrounds)
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
    @Previewable @State var model = [UIImage.crazyBackground1,
                                     .crazyBackground2,
                                     .crazyBackground3]
    EditBackgroundView(backgrounds: $model)
}
