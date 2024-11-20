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
            return Project(
                storage: Storage(
                    folder: FileManager.default.urls(
                        for: .documentDirectory, in: .userDomainMask
                    ).first!))
//            let databasePath = URL.documentsDirectory.appending(
//                path: "db.sqlite"
//            )
//            .path()
//            print("open", databasePath)
//            let databaseQueue = try DatabaseQueue(path: databasePath)
//            return Project(storage: try DBStorage(databaseQueue: databaseQueue))
        } catch {
            fatalError(error.localizedDescription)
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(project: $project)
        }
    }
}
