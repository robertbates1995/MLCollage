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
    @State private var showingExporter = false
    private var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            ScrollView {
                    LazyVGrid(columns: gridItemLayout, spacing: 20) {
                        ForEach(project.projectData, id: \.self) { collage in
                            Image(collage.image)
                                .font(.system(size: 30))
                                .frame(width: 50, height: 50)
                                .cornerRadius(10)
                        }
                    }
                }
            Button("export") {
                showingExporter.toggle()
            }.fileExporter(isPresented: $showingExporter, document: TrainingDataFile(project: project), defaultFilename: "foo") { _ in
                
            }
        }
    }
}



#Preview {
    //replace this with actual output photos
    @Previewable @State var model = Project.mock
    OutputsView(project: $model)
}
