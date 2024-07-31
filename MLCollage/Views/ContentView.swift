//
//  NavigationView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

enum SideBarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case settings
    case files
}

struct ContentView: View {
    
    
    var body: some View {
        Text("placeholder")
    }
}

#Preview {
    ContentView()
}
