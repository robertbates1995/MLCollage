//
//  OutputView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct FilesView: View {
    @State private var imageCreator = ImageCreator(
        background: NSImage(resource: .forest),
        subject: NSImage(resource: .monke)
    )
    
    var body: some View {
        VStack {
            Text("Files View")
                .font(.headline)
            Spacer()
            HSplitView {
                CreateScrollView(
                    [imageCreator.subject,
                     imageCreator.subject,
                     imageCreator.subject,
                     imageCreator.subject,
                     imageCreator.subject,
                     imageCreator.subject],
                    title: "Subjects")
                CreateScrollView(
                    [imageCreator.background,
                     imageCreator.background,
                     imageCreator.background,
                     imageCreator.background,
                     imageCreator.background,
                     imageCreator.background],
                    title: "Backgrounds")
            }
            .padding()
            .background()
            
        }
        .padding()
    }
    
    func CreateScrollView(_ images: [NSImage], title: String) -> some View {
        var count = images.count
        return ScrollView {
            HStack {
                Text(title)
                Spacer()
            }
            Image(nsImage: images[count - 1])
                .resizable()
                .scaledToFit()
                .padding()
        }
    }
}

#Preview {
    FilesView()
}
