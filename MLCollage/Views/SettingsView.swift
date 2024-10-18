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
            SettingView(title: "population", value: $settings.population, upperValue: $settings.population, range: 0...100, hasLower: false)
            SettingView(title: "number of each subject", value: $settings.numberOfEachSubject, upperValue: $settings.numberOfEachSubject, range: 0...20, hasLower: false)
            SettingView(title: "translation", value: $settings.translateLowerBound, upperValue: $settings.translateUpperBound, range: 0...100, hasLower: true)
        }.scrollDisabled(true)
    }
}

struct SettingView: View {
    let title: String
    @Binding var value: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>
    let hasLower: Bool
    
    var body: some View {
        if hasLower {
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

#Preview {
    @Previewable @State var model = ProjectSettings()
    SettingsView(settings: $model)
}
