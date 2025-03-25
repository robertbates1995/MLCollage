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
            List {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.black.opacity(0.05), .black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 10
                    ) {
                        ForEach(model.backgrounds) { image in
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
                }
            }
            .navigationTitle("Backgrounds")
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    BackgroundsView(model: $model)
}
