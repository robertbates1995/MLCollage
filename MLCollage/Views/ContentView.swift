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
            Tab("Inputs", systemImage: "rightArrow") {
                InputsView(subjects: project.subjects, backgrounds: project.backgrounds)
            }
            Tab("settings", systemImage: "page") {
                SettingsView(settings: $project.settings)
            }
            Tab("output", systemImage: "pencil") {
                OutputsView(project: $project)
            }
        }
    }
}

#Preview {
    @Previewable @State var model = Project.mock
    ContentView(project: $model)
}
