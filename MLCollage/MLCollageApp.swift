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
    @State var project: Project = {
        do {
            let databasePath = URL.documentsDirectory.appending(
                path: "db.sqlite"
            )
            .path()
            print("open", databasePath)
            let databaseQueue = try DatabaseQueue(path: databasePath)
            return Project(storage: try DBStorage(databaseQueue: databaseQueue))
        } catch {
            return Project.mock
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(project: $project)
        }
    }
}
