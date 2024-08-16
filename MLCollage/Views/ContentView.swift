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
        Text("placeholder")
        NavigationSplitView(
            columnVisibility: $visibility,
            sidebar: {SidebarView(creator.createCollageSet())},
            detail: { DetailView() })
    }
    
    struct SidebarView: View {
        var collages: [Collage]
        
        init( _ collages: [Collage]) {
            self.collages = collages
        }
        
        var body: some View {
            Text("sidebar")
        }
    }
    
    struct DetailView: View {
        var body: some View {
            Text("detail")
        }
    }
}

#Preview {
    ContentView()
}
