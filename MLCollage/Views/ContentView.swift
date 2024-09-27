//
//  NavigationView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var project = Project()
    
    var body: some View {
        TabView {
            Tab("Inputs", systemImage: "rightArrow") {
                InputsView(subjects: project.subjects.map(\.image), backgrounds: project.backgrounds)
            }
            Tab("settings", systemImage: "page") {
                SettingsView(settings: project.settings)
            }
            Tab("output", systemImage: "pencil") {
                OutputsView(outputs: project.projectData.map(\.image))
            }
        }
    }
}

#Preview {
    ContentView()
}
