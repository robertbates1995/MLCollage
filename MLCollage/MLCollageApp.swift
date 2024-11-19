//
//  MLCollageApp.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import GRDB
import SwiftUI

@main
struct MLCollageApp: App {
    @State var project = Project(
        storage: Storage(
            folder: FileManager.default.urls(
                for: .documentDirectory, in: .userDomainMask
            ).first!))

    init() {
        do {
            let databasePath = URL.documentsDirectory.appending(
                path: "db.mlcollage"
            )
            .path()
            let databaseQueue = try DatabaseQueue(path: databasePath)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(project: $project)
        }
    }
}
