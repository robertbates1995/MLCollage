//
//  SettingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

enum NumberOfSubject: String, CaseIterable, Identifiable {
    case chocolate, vanilla, strawberry
    var id: Self { self }
}




struct SettingsView: View {
    @Binding var settings: SettingsModel
    @State var width: CGSize = .zero

    var body: some View {
        NavigationView {
            List {
                //number of each subject
                SliderView(
                    title: "number of each subject",
                    value: $settings.numberOfEachSubject,
                    range: 5...100)
                //translation range
                Section("Translation") {
                    Toggle("Translate", isOn: $settings.translate)
                }
                //scale range
                HighLowSliderView(
                    title: "rotation",
                    value: $settings.scaleLowerBound,
                    upperValue: $settings.scaleUpperBound,
                    range: 0.5...1.5)
                //rotate range
                HighLowSliderView(
                    title: "scale",
                    value: $settings.rotateLowerBound,
                    upperValue: $settings.rotateUpperBound,
                    range: 0.0...0.5)
                //flip toggle
                Section("flip") {
                    Toggle("Horizontal", isOn: $settings.flipHorizontal)
                    Toggle("Vertical", isOn: $settings.flipVertical)
                }
            }
            .scrollDisabled(true)
            .navigationTitle("Settings")
        }
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
                HighLowSlider(
                    highValue: $upperValue, lowValue: $value, range: range)
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
    @Previewable @State var model = SettingsModel()
    SettingsView(settings: $model)
}
