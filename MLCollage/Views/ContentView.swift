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
    
    //splash screen variables
    @State var isActive = false
    @State var size = 0.8
    @State var opacity = 0.5
    
    var body: some View {
        if isActive {
            TabView {
                Tab("Inputs", systemImage: "square.and.arrow.down.on.square") {
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
            }
        } else {
            VStack {
                VStack {
                    Image(.mlCollageIconLight)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("ML Collage")
                        .font(.title)
                }
                .padding(120.0)
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var model = Project.mock
    ContentView(project: $model)
}
