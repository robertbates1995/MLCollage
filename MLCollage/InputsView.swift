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
            ZStack {
                Image(nsImage: imageCreator.createImage())
                    .resizable()
                    .scaledToFit()
            }
        }
        .padding()
    }
}

#Preview {
    InputsView()
}
