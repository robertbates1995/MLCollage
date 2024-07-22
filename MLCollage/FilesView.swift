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
                ScrollView {
                    HStack {
                        Text("subjects")
                        Spacer()
                    }
                    Image(nsImage:imageCreator.subject)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                ScrollView {
                    HStack {
                        Text("backgrounds")
                        Spacer()
                    }
                    Image(nsImage: imageCreator.background)
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
            }
            .padding()
            .background()
            
        }
        .padding()
    }
}

#Preview {
    FilesView()
}
