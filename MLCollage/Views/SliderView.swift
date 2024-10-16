//
//  SliderValue.swift
//  MLCollage
//
//  Created by Robert Bates on 10/8/24.
//


import SwiftUI
import Combine

struct SliderView: View {
    @ObservedObject var slider: CustomSlider
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: slider.lineWidth)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: slider.lineWidth)
                    .overlay(
                        ZStack {
                            //Path between both handles
                            SliderPathBetweenView(slider: slider, sliderWidth: proxy.size.width)
                            
                            //Low Handle
                            SliderHandleView(handle: slider.lowHandle, sliderWidth: proxy.size.width)
                                .highPriorityGesture(slider.lowHandle.sliderDragGesture(sliderWidth: proxy.size.width))
                            
                            //High Handle
                            SliderHandleView(handle: slider.highHandle, sliderWidth: proxy.size.width)
                                .highPriorityGesture(slider.highHandle.sliderDragGesture(sliderWidth: proxy.size.width))
                        }
                    )
                Spacer()
            }
        }
    }
}

struct SliderHandleView: View {
    @ObservedObject var handle: SliderHandle
    let sliderWidth: CGFloat
    
    var body: some View {
        Circle()
            .frame(width: handle.diameter, height: handle.diameter)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 0)
            .scaleEffect(handle.onDrag ? 1.3 : 1)
            .contentShape(Rectangle())
            .position(x: handle.currentLocation(sliderWidth: sliderWidth).x, y: handle.currentLocation(sliderWidth: sliderWidth).y)
    }
}

struct SliderPathBetweenView: View {
    @ObservedObject var slider: CustomSlider
    let sliderWidth: CGFloat
    
    var body: some View {
        Path { path in
            path.move(to: slider.lowHandle.currentLocation(sliderWidth: sliderWidth))
            path.addLine(to: slider.highHandle.currentLocation(sliderWidth: sliderWidth))
        }
        .stroke(Color.blue, lineWidth: slider.lineWidth)
    }
}

class CustomSlider: ObservableObject {
    
    //Slider Size
    let lineWidth: CGFloat = 4
    
    //Slider value range from valueStart to valueEnd
    let valueStart: Double
    let valueEnd: Double
    
    //Slider Handle
    @Published var highHandle: SliderHandle
    @Published var lowHandle: SliderHandle
    
    var anyCancellableHigh: AnyCancellable?
    var anyCancellableLow: AnyCancellable?
    
    init(start: Double, end: Double) {
        valueStart = start
        valueEnd = end
        
        highHandle = SliderHandle(sliderHeight: lineWidth,
                                  sliderValueStart: valueStart,
                                  sliderValueEnd: valueEnd,
                                  startPercentage: 1.0
                                  
        )
        
        lowHandle = SliderHandle(sliderHeight: lineWidth,
                                 sliderValueStart: valueStart,
                                 sliderValueEnd: valueEnd,
                                 startPercentage: 0.0
        )
        
        anyCancellableHigh = highHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
        anyCancellableLow = lowHandle.objectWillChange.sink { _ in
            self.objectWillChange.send()
        }
    }
    
    //Percentages between high and low handle
    var percentagesBetween: String {
        return String(format: "%.2f", highHandle.currentPercentage - lowHandle.currentPercentage)
    }
    
    //Value between high and low handle
    var valueBetween: String {
        return String(format: "%.2f", highHandle.currentValue - lowHandle.currentValue)
    }
}

class SliderHandle: ObservableObject {
    
    //Slider Size
    let sliderHeight: CGFloat
    
    //Slider Range
    let sliderValueStart: Double
    let sliderValueRange: Double
    
    //Slider Handle
    var diameter: CGFloat = 28
    
    //Current Value
    @Published var currentPercentage: Double
    
    //Slider Button Location
    @Published var onDrag: Bool
    
    func currentLocation(sliderWidth: CGFloat) -> CGPoint {
        CGPoint(x: (CGFloat(currentPercentage))*sliderWidth, y: sliderHeight/2)
    }
    
    init(sliderHeight: CGFloat, sliderValueStart: Double, sliderValueEnd: Double, startPercentage: Double) {
        self.sliderHeight = sliderHeight
        
        self.sliderValueStart = sliderValueStart
        self.sliderValueRange = sliderValueEnd - sliderValueStart
        
        self.currentPercentage = startPercentage
        
        self.onDrag = false
    }
    
    func sliderDragGesture(sliderWidth: CGFloat) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture()
            .onChanged { value in
                self.onDrag = true
                
                let dragLocation = value.location
                
                //Restrict possible drag area
                self.restrictSliderBtnLocation(dragLocation, sliderWidth: sliderWidth)
                
                //Get current value
                self.currentPercentage = Double(self.currentLocation(sliderWidth: sliderWidth).x / sliderWidth)
                
            }.onEnded { _ in
                self.onDrag = false
            }
    }
    
    private func restrictSliderBtnLocation(_ dragLocation: CGPoint, sliderWidth: CGFloat) {
        //On Slider Width
        if dragLocation.x > CGPoint.zero.x && dragLocation.x < sliderWidth {
            calcSliderBtnLocation(dragLocation, sliderWidth: sliderWidth)
        }
    }
    
    private func calcSliderBtnLocation(_ dragLocation: CGPoint, sliderWidth: CGFloat) {
        if dragLocation.x > 0 {
            currentPercentage = dragLocation.x / sliderWidth
        } else {
            currentPercentage = 0.0
        }
    }
    
    //Current Value
    var currentValue: Double {
        return sliderValueStart + currentPercentage * sliderValueRange
    }
}
