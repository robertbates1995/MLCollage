//
//  SettingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct SettingsView: View {
    @State var settings: ProjectSettings
    
    var body: some View {
        List {
            SettingView("population", value: settings.population, range: 0...100)
            SettingView("number of each subject", value: settings.numberOfEachSubject, range: 0...20)
            SettingView("translation", value: settings.translateLowerBound, upperValue: settings.translateUpperBound, range: 0...100, hasLower: true)
        }.scrollDisabled(true)
    }
}

#Preview {
    SettingsView(settings: ProjectSettings())
}

struct SettingView: View {
    @State var value: Double
    @State var upperValue: Double
    let range: ClosedRange<Double>
    let title: String
    let hasLower: Bool
    
    init(_ title: String, value: Double, upperValue: Double = 0.0, range: ClosedRange<Double>, hasLower: Bool = false) {
        self.value = value
        self.upperValue = upperValue
        self.range = range
        self.title = title
        self.hasLower = hasLower
    }
    
    var body: some View {
        if hasLower {
            Section(title) {
                HStack {
                    Text("Lower Value: ")
                    Text(String(format: "%g", value.rounded()))
                    Spacer()
                    Text("Upper Value: ")
                    Text(String(format: "%g", upperValue.rounded()))
                }
                SliderView(slider: CustomSlider(start: value, end: upperValue))
            }
        } else {
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
}
