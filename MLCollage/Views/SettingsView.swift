//
//  SettingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: ProjectSettings
    @State var width: CGSize = .zero
    
    var body: some View {
        List {
            SliderView(title: "population", value: $settings.population, range: 0...100)
            SliderView(title: "number of each subject", value: $settings.numberOfEachSubject, range: 0...20)
            HighLowSliderView(title: "translation", value: $settings.translateLowerBound, upperValue: $settings.translateUpperBound, range: 0...100)
        }.scrollDisabled(true)
    }
}

struct HighLowSliderView: View {
    let title: String
    @Binding var value: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        Section(title) {
            HStack {
                Text("Lower Value: ")
                Text(String(format: "%g", value))
                Spacer()
                Text("Upper Value: ")
                Text(String(format: "%g", upperValue))
            }
            VStack {
                HighLowSlider(highValue: $upperValue, lowValue: $value, range: range)
            }
        }
    }
}

struct SliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    
    var body: some View {
        Section(title) {
            HStack {
                Text(String(format: "%g", value.rounded()))
            }
            Slider(value: $value, in: range) {
                Text("population")
            } onEditingChanged: { _ in
                value = value.rounded()
                print("\(value)")
            }
        }
    }
}

#Preview {
    @Previewable @State var model = ProjectSettings()
    SettingsView(settings: $model)
}
