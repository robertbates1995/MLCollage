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

    var body: some View {
        NavigationView {
            LazyVGrid(
                columns: [ GridItem(.flexible()),
                           GridItem(.flexible()),],
                spacing: 10
            ) {
                ForEach(model.backgrounds) { image in  // Replace with your data model here
                    Image(uiImage: image.uiImage)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            minWidth: 0, maxWidth: .infinity, minHeight: 0,
                            maxHeight: .infinity, alignment: .center
                        )
                        .aspectRatio(1 / 1, contentMode: .fit)
                        .clipped()
                        .mask {
                            RoundedRectangle(
                                cornerRadius: 6, style: .continuous)
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    BackgroundsView(model: $model)
}
