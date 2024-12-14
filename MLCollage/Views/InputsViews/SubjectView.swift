//
//  ContentView.swift
//  suygfshiudrhiu
//
//  Created by Robert Bates on 10/30/24.
//

import PhotosUI
import SwiftUI
import UIKit

//struct SubjectView: View {
//    @Binding var images: [UIImage]
//
//    var body: some View {
//        ScrollView {
//            VStack {
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 20)
//                {
//                    ForEach(images, id: \.self) { image in
//                        subjectImage(image)
//                    }
//                }
//            }
//        }
//    }
//    
//    fileprivate func subjectImage(_ image: UIImage) -> some View {
//        return Image(uiImage: image)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .background(Color.gray.opacity(0.5))
//            .cornerRadius(5.0)
//    }
//}

#Preview {
    @Previewable @State var model = InputModel.mock.backgrounds
    SubjectView(images: $model)
}
