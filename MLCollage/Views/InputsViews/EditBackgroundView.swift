import UIKit
import SwiftUI
import PhotosUI

struct EditBackgroundView: View {
    @Binding var backgrounds: [MLCImage]
    @State private var isDeleting = false
    @Environment(\.dismiss) var dismiss
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    func addImage(_ image: MLCImage) {
        backgrounds.append(image)
    }
    
    var body: some View {
        VStack {
            SubjectView(
                images: $backgrounds, editing: isDeleting
            )
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
                            addImage(MLCImage(uiImage: image))
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
                PhotosPicker(
                    "Add Backgrounds", selection: $photosPickerItems,
                    maxSelectionCount: 10, selectionBehavior: .ordered)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    dismiss()
                }
            }
        }
        .foregroundColor(.accent)
    }
}

#Preview {
    @Previewable @State var model = [UIImage.crazyBackground1,
                                     .crazyBackground2,
                                     .crazyBackground3].map({MLCImage(uiImage: $0)})
    NavigationView {
        EditBackgroundView(backgrounds: $model)
    }
}
