//
//  SettingsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var settings: SettingsModel
    @State var width: CGSize = .zero

    var resolutions = [100, 200, 300]
    @State private var selectedResolution = 200

    var body: some View {
        NavigationView {
            List {
                //number of each subject
                SliderView(
                    title: "number of each subject",
                    value: $settings.numberOfEachSubject,
                    range: 5...10000)
                //translation toggle
                Toggle("Translate", isOn: $settings.translate)
                //rotate toggle
                Toggle("rotate", isOn: $settings.rotate)
                //scale toggle
                Toggle("scale", isOn: $settings.scale)
                //flip toggle
                Section("flip") {
                    Toggle("Horizontal", isOn: $settings.flipHorizontal)
                    Toggle("Vertical", isOn: $settings.flipVertical)
                }
            }
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
