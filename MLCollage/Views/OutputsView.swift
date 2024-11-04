//
//  OutputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct OutputsView: View {
    @Binding var project: Project
    @State var collages: [Collage]?
    @State  var showingExporter = false
    #warning("todo: use the following to create a slider to dictate minimum photo size")
    @State var minSize: CGFloat = 100.0
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: minSize))], spacing: 20) {
                    if let collages {
                        ForEach(collages) { collage in
                            Image(uiImage: collage.image.toUIImage())
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
            }
            Button("export") {
                showingExporter.toggle()
            }.fileExporter(isPresented: $showingExporter, document: TrainingDataFile(project: project), defaultFilename: "foo") { _ in
                
            }
        }.task {
            if (collages == nil) {
                await createOutputs()
                collages = project.projectData
            }
        }.padding()
    }
    
    nonisolated func createOutputs() async {
        let _ = await project.createJSON()
        print("here")
    }
}



#Preview {
    //replace this with actual output photos
    @Previewable @State var model = Project.mock
    OutputsView(project: $model)
}
