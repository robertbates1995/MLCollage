//
//  HighLowSlider.swift
//  MLCollage
//
//  Created by Robert Bates on 10/16/24.
//

import SwiftUI

struct HighLowSlider: View {
    //TODO:
    //do the same for highValue as you did for lowValue
    //get pathBetween working
    
    @Binding var highValue: Double
    @Binding var lowValue: Double
    @State var lowDrag: Bool = false
    
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 4.0)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4.0)
                    .overlay(
                        ZStack {
                            HandleView(diameter: 28, onDrag: false, currentLocation:  CGPoint(x: lowValue * proxy.size.width, y: 2))
                                .highPriorityGesture(DragGesture()
                                    .onChanged { value in
                                        self.lowDrag = true
                                        self.lowValue = value.location.x / proxy.size.width
                                    }.onEnded { _ in
                                        self.lowDrag = false
                                    })
                        }
                    )
                Spacer()
            }
        }
    }
}

fileprivate struct HandleView: View {
    let diameter: Double
    let onDrag: Bool
    let currentLocation: CGPoint
    
    var body: some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .foregroundColor(.red)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
            .scaleEffect(onDrag ? 1.3 : 1)
            .contentShape(Rectangle())
            .position(currentLocation)
    }
}

#Preview {
    @Previewable @State var high = 1.0
    @Previewable @State var low = 0.0
    
    VStack(alignment: .leading) {
        Text("High:" + high.formatted())
        Text("Low::" + low.formatted())
        HighLowSlider(highValue: $high, lowValue: $low)
    }.padding()
}
