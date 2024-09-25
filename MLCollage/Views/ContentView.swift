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
    @State var visibility: NavigationSplitViewVisibility = .all
    @State var creator = Project()
    
    var body: some View {
        TabView {
            Tab("Inputs", systemImage: "rightArrow") {
                Text("This is a blog page")
            }
            Tab("settings", systemImage: "page") {
                Text("This is a blog page")
            }
            Tab("output", systemImage: "pencil") {
                Text("This is a blog page")
            }
        }
    }
}

#Preview {
    ContentView()
}
