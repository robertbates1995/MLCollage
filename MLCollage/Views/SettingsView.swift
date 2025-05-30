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
            List{
                SliderView(
                    title: "number of each subject",
                    value: $settings.numberOfEachSubject,
                    range: 10...1000
                )
                //translation toggle
                Toggle("Translate", isOn: $settings.translate)
                //rotate toggle
                Toggle("rotate", isOn: $settings.rotate)
                //scale toggle
                Toggle("scale", isOn: $settings.scale)
                //flip toggle
                Toggle("Mirror", isOn: $settings.mirror)
                Section("Resolution") {
                    Picker("Resolution", selection: $settings.outputSize) {
                        ForEach(Outputsize.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .navigationTitle("Settings")
        .foregroundColor(.accent)
    }
}

struct SliderView: View {
    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step = 10.0

    var body: some View {
        HStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Subjects:")
                    Spacer()
                    Text(String(format: "%g", value.rounded()))
                    Spacer()
                }
                HStack {
                    Stepper(
                                value: $value,
                                in: range,
                                step: step
                            ) {
                                Slider(value: $value, in: range) {
                                    Text("population")
                                } onEditingChanged: { _ in
                                    value = value.rounded()
                                    print("\(value)")
                                }
                            }
                            .padding(10)
                }
               
            }
        }
    }
}

#Preview {
    @Previewable @State var model = SettingsModel()
    SettingsView(settings: $model)
}
