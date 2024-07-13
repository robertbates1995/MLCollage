//
//  ContentView.swift
//  MLCollage
//
//  Created by Robert Bates on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            FileNavigationView()
            InputsView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
