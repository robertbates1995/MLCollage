//
//  MLCollageApp.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

@main
struct MLCollageApp: App {
    @State var project = Project.mock
    
    var body: some Scene {
        WindowGroup {
            ContentView(project: $project)
        }
    }
}
