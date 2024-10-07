//
//  SettingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct SettingsView: View {
    @State var settings: ProjectSettings
    
    var body: some View {
        VStack{
            Text("Settings")
            
            List {
                Section ("Population"){
                    HStack {
                        Text(String(format: "%g", settings.population.rounded()))
                    }
                    Slider(value: $settings.population, in: 0...100) {
                        Text("population")
                    } onEditingChanged: { _ in
                        settings.population = settings.population.rounded()
                        print("\(settings.population)")
                    }
                }
            }.scrollDisabled(true)
        }
    }
}

#Preview {
    SettingsView(settings: ProjectSettings())
}
