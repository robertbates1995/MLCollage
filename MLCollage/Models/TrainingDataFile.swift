//
//  TrainingDataFile.swift
//  MLCollage
//
//  Created by Robert Bates on 10/28/24.
//

import SwiftUI
import UniformTypeIdentifiers


struct TrainingDataFile: FileDocument {
    static let readableContentTypes: [UTType] = [.json, .png]
    let project: Project
    
    init(project: Project) {
        self.project = project
    }
    
    init(configuration: ReadConfiguration) throws {
        fatalError()
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var json = project.createJSON()
        var images = project.projectData
        var temp = ["project.json": FileWrapper(regularFileWithContents: json)]
        var count = 0
        
        for i in images {
            if let data = UIImage(ciImage: i.image).pngData() {
                temp["\(count).png"] = FileWrapper(regularFileWithContents: data)
                count += 1
            }
        }
        
        return FileWrapper(directoryWithFileWrappers: temp)
    }
}
