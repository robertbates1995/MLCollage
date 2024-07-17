//
//  OutputView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct InputsView: View {
    @State private var imageCreator = ImageCreator()
    
    var body: some View {
        VStack {
            Text("Inputs View")
            ZStack {
                Image(nsImage: imageCreator.forestImage)
                    .resizable()
                    .scaledToFit()
                Image(nsImage: imageCreator.forestImage)
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
