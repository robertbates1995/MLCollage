//
//  NavigationView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var visibility: NavigationSplitViewVisibility = .all
    @Binding var project: Project
    
    var body: some View {
        TabView {
            Tab("Inputs", systemImage: "square.and.arrow.down.on.square") {
                AllSubjectsView(model: $project.inputModel)
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView(settings: $project.settingsModel)
            }
            Tab("Output", systemImage: "text.below.photo") {
                OutputsView(model: $project.outputModel)
            }
        }
    }
}

#Preview {
    @Previewable @State var model = Project.mock
    ContentView(project: $model)
}
