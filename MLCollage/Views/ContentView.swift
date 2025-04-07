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
    
    @State private var isDarkMode = false
    @Environment(\.colorScheme) private var colorScheme
    
    //splash screen variables
    @State var isActive = false
    @State var size = 0.7
    @State var opacity = 0.5
    
    var body: some View {
        if isActive {
            TabView {
                Tab("Subjects", systemImage: "square.and.arrow.down.on.square") {
                    AllSubjectsView(model: $project.inputModel)
                }
                Tab("Backgrounds", systemImage: "photo") {
                    BackgroundsView(model: $project.inputModel)
                }
                Tab("Settings", systemImage: "gearshape") {
                    SettingsView(settings: $project.settingsModel)
                }
                Tab("Output", systemImage: "text.below.photo") {
                    OutputsView(model: $project.outputModel)
                }
                Tab("About", systemImage: "questionmark.circle") {
                    AboutView()
                }
            }
            .tint(.accent)
        } else {
            VStack {
                VStack {
                    Image(colorScheme == .dark ? .mlCollageIconDark : .mlCollageIconLight)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                Text("ML Collage")
                    .font(.title)
            }
            .padding(120.0)
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 2.0)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var model = Project.mock
    ContentView(project: $model).preferredColorScheme(.light)
}

#Preview {
    @Previewable @State var model = Project.mock
    ContentView(project: $model).preferredColorScheme(.dark)
}
