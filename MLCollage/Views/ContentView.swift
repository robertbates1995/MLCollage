//
//  NavigationView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var project = Project.mock
    
    var body: some View {
        TabView {
            Tab("Inputs", systemImage: "rightArrow") {
                InputsView(subjects: project.subjects.map({$0.image.toUIImage()}), backgrounds: project.backgrounds.map({$0.toUIImage()}))
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
