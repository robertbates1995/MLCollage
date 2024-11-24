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
            ForEach($model.subjects) { subject in
                Section(subject.label.wrappedValue) {
                    SubjectView(
                        images: subject.images)
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
