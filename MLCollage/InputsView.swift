//
//  OutputView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct InputsView: View {
    @State private var imageCreator = ImageCreator(
        background: NSImage(resource: .forest),
        subject: NSImage(resource: .monke)
    )
    
    var body: some View {
        VStack {
            Text("Inputs View")
                .font(.headline)
            Spacer()
            HSplitView {
                ScrollView {
                    Image(nsImage: imageCreator.background)
                        .resizable()
                        .scaledToFit()
                    Image(nsImage:imageCreator.subject)
                        .resizable()
                        .scaledToFit()
                }
                ScrollView {
                    Image(nsImage: imageCreator.background)
                        .resizable()
                        .scaledToFit()
                    Image(nsImage:imageCreator.subject)
                        .resizable()
                        .scaledToFit()
                }
            }
            .padding()
            .background()
            
        }
        .padding()
    }
}

#Preview {
    InputsView()
}
