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
                SettingView("population", value: settings.population, range: 0...100)
            }.scrollDisabled(true)
        }
    }
}

#Preview {
    SettingsView(settings: ProjectSettings())
}

struct SettingView: View {
    @State var value: Double
    let range: ClosedRange<Double>
    let title: String
    
    init(_ title: String, value: Double, range: ClosedRange<Double>) {
        self.value = value
        self.range = range
        self.title = title
    }
    
    var body: some View {
        Section (title) {
            HStack {
                Text(String(format: "%g", value.rounded()))
            }
            Slider(value: $value, in: range) {
                Text("population")
            } onEditingChanged: { _ in
                value = value.rounded()
                print("\(value)")
            }
        }
    }
}
