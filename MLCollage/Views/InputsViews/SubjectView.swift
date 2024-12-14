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
    @Binding var images: [UIImage]
    let isEditing: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 20)
                {
                    ForEach(images, id: \.self) { image in
                            if isEditing {
                                NavigationLink(destination: subjectImage(image)) {
                                    subjectImage(image)
                                }
                            } else {
                                subjectImage(image)
                            }
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
    @Previewable @State var model = InputModel.mock.backgrounds
    NavigationView {
        SubjectView(images: $model, isEditing: true)
    }
}
