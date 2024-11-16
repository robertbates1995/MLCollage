//
//  TrainingDataFile.swift
//  MLCollage
//
//  Created by Robert Bates on 10/28/24.
//

import SwiftUI
import UniformTypeIdentifiers


struct TrainingDataFile: FileDocument {
    static let readableContentTypes: [UTType] = [.json, .png, .folder]
    let collages: [Collage]
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        var fileStructure = ["project.json": FileWrapper(regularFileWithContents: collages.json)]
        var count = 0
        
        for i in collages {
            if let data = i.image.pngData() {
                fileStructure["\(count).png"] = FileWrapper(regularFileWithContents: data)
                count += 1
            }
        }
        return FileWrapper(directoryWithFileWrappers: fileStructure)
    }
}

extension TrainingDataFile {
    init(configuration: ReadConfiguration) throws {
        fatalError()
    }
}
