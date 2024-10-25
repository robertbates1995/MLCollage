//
//  OutputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct OutputsView: View {
    @State var outputs: CIImageFile
    @State private var showingExporter = false

    var body: some View {
        HStack {
            Text("This is an output page")
            Button("export") {
                showingExporter.toggle()
            }
        }.fileExporter(isPresented: $showingExporter, document: outputs, contentType: .png) { result in
            switch result {
            case .success(let url):
                print("Saved to \(url)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct CIImageFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.png, UTType.json]

    // by default our document is empty
    var photos: [CIImage] = []
    var json = ""

    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        photos = initialText
    }

    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            photos = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(photos.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

#Preview {
    //replace this with actual output photos
    OutputsView(outputs: [CIImage(image: .crazyBackground1)!,
                          CIImage(image: .crazyBackground2)!,
                          CIImage(image: .crazyBackground3)!])
}
