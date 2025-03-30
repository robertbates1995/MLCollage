//
//  SplashScreenView.swift
//  MLCollage
//
//  Created by Robert Bates on 3/29/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive = false
    @State var size = 0.8
    @State var opacity = 0.5
    
    var body: some View {
        VStack {
            VStack {
                Image(.mlCollageIconLight)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Text("ML Collage")
                    .font(.title)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.size = 0.9
                    self.opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
