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
    @State var highDrag: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 4.0)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 4.0)
                    .overlay(
                        ZStack {
                            PathBetweenView(lineWidth: 4.0, lowValue: location(lowValue, proxy), highValue: location(highValue, proxy))
                            //low handle
                            HandleView(diameter: 28, onDrag: lowDrag, at: location(lowValue, proxy))
                                .highPriorityGesture(DragGesture()
                                    .onChanged { value in
                                        self.lowDrag = true
                                        let tempValue = value.location.x / proxy.size.width
                                        self.lowValue = min(tempValue, highValue)
                                    }.onEnded { _ in
                                        self.lowDrag = false
                                    })
                            //high handle
                            HandleView(diameter: 28, onDrag: highDrag, at:  location(highValue, proxy))
                                .highPriorityGesture(DragGesture()
                                    .onChanged { value in
                                        self.highDrag = true
                                        let tempValue = value.location.x / proxy.size.width
                                        self.highValue = max(tempValue, lowValue)
                                    }.onEnded { _ in
                                        self.highDrag = false
                                    })
                        }
                    )
                Spacer()
            }
        }
    }
    
    func location(_ value: Double, _ proxy: GeometryProxy) -> CGPoint {
        CGPoint(x: (value * proxy.size.width), y: 2)
    }
}

fileprivate struct PathBetweenView: View {
    let lineWidth: CGFloat
    let lowValue: CGPoint
    let highValue: CGPoint
    
    var body: some View {
        Path { path in
            path.move(to: lowValue)
            path.addLine(to: highValue)
        }
        .stroke(Color.blue, lineWidth: lineWidth)
    }
}

fileprivate struct HandleView: View {
    let diameter: Double
    let onDrag: Bool
    let at: CGPoint
    
    var body: some View {
        Circle()
            .frame(width: diameter, height: diameter)
            .foregroundColor(.red)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
            .scaleEffect(onDrag ? 1.3 : 1)
            .contentShape(Rectangle())
            .position(at)
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
