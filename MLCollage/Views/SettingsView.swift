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
        Text("This is a settings page")
    }
}

#Preview {
    SettingsView(settings: ProjectSettings())
}
