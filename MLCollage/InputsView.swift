//
//  OutputView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct InputsView: View {
    var body: some View {
        VStack {
            Text("Inputs View")
            ZStack {
                Image("forest")
                    .resizable()
                    .scaledToFit()
                Image("monke")
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
