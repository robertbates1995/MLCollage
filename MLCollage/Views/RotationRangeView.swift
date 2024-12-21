//
//  RotationRangeView.swift
//  MLCollage
//
//  Created by Robert Bates on 12/20/24.
//


import SwiftUI

struct RotationRangeView: View {
    @State private var minRotation: Double = 0
    @State private var maxRotation: Double = 360
    @State private var currentRotation: Double = 0

    var body: some View {
        VStack(spacing: 20) {
            Text("Rotation Range Selector")
                .font(.title)
                .padding()

            VStack {
                Text("Min Rotation: \(Int(minRotation))°")
                Slider(value: $minRotation, in: 0...360, step: 1)
            }
            .padding()

            VStack {
                Text("Max Rotation: \(Int(maxRotation))°")
                Slider(value: $maxRotation, in: 0...360, step: 1)
            }
            .padding()

            Button(action: applyMinRotation) {
                Text("Apply Rotation")
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(currentRotation))
                Text("Object")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .animation(.easeInOut(duration: 0.5), value: currentRotation)
            .padding()

            Spacer()
        }
        .padding()
    }

    func applyRotation() {
        // Generate a random rotation within the selected range
        guard minRotation <= maxRotation else { return }
        currentRotation = Double.random(in: minRotation...maxRotation)
    }
    
    func applyMinRotation() {
        // Generate the minimum rotation within the selected range
        guard minRotation <= maxRotation else { return }
        currentRotation = minRotation
    }
    
    func applyMaxRotation() {
        // Generate the maximum rotation within the selected range
        guard minRotation <= maxRotation else { return }
        currentRotation = maxRotation
    }
}

struct RotationRangeView_Previews: PreviewProvider {
    static var previews: some View {
        RotationRangeView()
    }
}
