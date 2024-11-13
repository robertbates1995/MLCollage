//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct AllSubjectsView: View {
    @Binding var model: InputModel
    @State var addNewSubject: Bool = false
    @State var editSubject: Bool = false
    @State var newSubject: Subject = Subject(label: "New Subject")

    var body: some View {
        List {
            ForEach(model.subjects.sorted(by: { $0.key < $1.key }), id: \.key) {
                (key, subject) in
                var subject = model.subjects[key]!
                Section(subject.label) {
                    SubjectView(
                        images: Binding(
                            get: { subject.images },
                            set: {
                                subject.images = $0
                                model.subjects[key] = subject
                            }))
                }
            }
            Section("Backgrounds") {
                SubjectView(images: $model.backgrounds)

            }
        }
        .padding()
        HStack {
            Button("Add Subject") {
                newSubject = model.newSubject
                addNewSubject.toggle()
            }
        }.sheet(
            isPresented: $addNewSubject,
            onDismiss: didDismiss
        ) {
            NewSubjectView(subject: $newSubject)
        }
    }

    func didDismiss() {
        model.add(subject: newSubject)
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    AllSubjectsView(model: $model)
}
