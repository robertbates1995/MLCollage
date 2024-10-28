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
    
    var body: some View {
        HStack {
            Text("This is an output page")
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
