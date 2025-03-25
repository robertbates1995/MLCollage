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
    @State var addNewBackground: Bool = false

    var body: some View {
        NavigationView {
            List {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [
                            .black.opacity(0.05), .black.opacity(0),
                        ]), startPoint: .top, endPoint: .bottom)
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
                                    minWidth: 0, maxWidth: .infinity,
                                    minHeight: 0,
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
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Select") {

                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            addNewBackground.toggle()
                        },
                        label: {
                            Image(systemName: "plus")
                        }
                    )
                }
            }
            .sheet(
                isPresented: $addNewBackground
            ) {
                NavigationView {
                    EditBackgroundView(backgrounds: $model.backgrounds)
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
