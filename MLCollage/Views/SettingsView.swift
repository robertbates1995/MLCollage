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
            Text("This is a settings page")
            Slider(value: $settings.population, in: 0...1000) {
                Text("Label")
            } minimumValueLabel: {
                Image(systemName: "tortoise")
            } maximumValueLabel: {
                Image(systemName: "hare")
            } onEditingChanged: {
                print("\($0)")
            }
        }
    }
}

#Preview {
    SettingsView(settings: ProjectSettings())
}
