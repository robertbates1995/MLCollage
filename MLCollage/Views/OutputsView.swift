//
//  OutputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct OutputsView: View {
    @Binding var model: OutputModel
    @State var showingExporter = false
    @State var minSize: CGFloat = 100.0

    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: minSize))],
                    spacing: 20
                ) {
                    ForEach(model.collages) { collage in
                        Image(uiImage: collage.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
            if model.canExport {
                Button("export") {
                    showingExporter.toggle()
                }.fileExporter(
                    isPresented: $showingExporter,
                    document: TrainingDataFile(collages: model.collages),
                    defaultFilename: "foo"
                ) { _ in
                    
                }
            }
        }.task {
            model.updateIfNeeded()
        }.padding()
    }
}

#Preview {
    //replace this with actual output photos
    @Previewable @State var model = OutputModel.mock
    OutputsView(model: $model)
}
