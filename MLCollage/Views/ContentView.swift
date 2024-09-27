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
                Text("This is an inputs page")
                InputsView(subjects: project.subjects.map(\.image), backgrounds: project.backgrounds)
            }
            Tab("settings", systemImage: "page") {
                Text("This is a settings page")
                //SettingsView()
            }
            Tab("output", systemImage: "pencil") {
                Text("This is an output page")
                //OutputView()
            }
        }
    }
}

#Preview {
    ContentView()
}
