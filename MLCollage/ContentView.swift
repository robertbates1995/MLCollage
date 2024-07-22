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
    case inputs
}

struct ContentView: View {
    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    @State var selectedSideBarItem: SideBarItem = .settings
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(SideBarItem.allCases, selection: $selectedSideBarItem) { item in
                NavigationLink(item.rawValue.localizedCapitalized, value: item)
            }
        } detail: {
            switch selectedSideBarItem {
            case .settings:
                SettingsView()
            case .inputs:
                InputsView()
            }
        }
    }
}

#Preview {
    ContentView()
}
