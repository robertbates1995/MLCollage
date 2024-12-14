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
    @State var addNewBackground: Bool = false
    @State var editSubject: Bool = false
    @State var newSubject: Subject = Subject(label: "New Subject")

    var body: some View {
        NavigationView {
            List {
                ForEach($model.subjects) { subject in
                    Section(subject.label.wrappedValue) {
                        ZStack {
                            Color.white
                            SubjectView(images: subject.images)
                        }
                    }
                    .onTapGesture {
                        newSubject = subject.wrappedValue
                        addNewSubject.toggle()
                    }
                }
                .onDelete { indexSet in
                    model.subjects.remove(atOffsets: indexSet)
                }
                Section("Backgrounds") {
                    ZStack {
                        Color.white
                        SubjectView(images: $model.backgrounds)
                    }
                }
                .onTapGesture {
                    addNewBackground.toggle()
                }
            }
            .navigationTitle("Input")
            .toolbar {
                Button("Add") {
                    newSubject = model.newSubject
                    addNewSubject.toggle()
                }
            }
            .sheet(
                isPresented: $addNewSubject,
                onDismiss: didDismiss
            ) {
                HStack {
                    Spacer()
                    Button("Save") {
                        
                    }
                    .padding()
                }
                EditSubjectView(subject: $newSubject)
            }
            .sheet(
                isPresented: $addNewBackground
            ) {
                EditBackgroundView(backgrounds: $model.backgrounds)
            }
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
