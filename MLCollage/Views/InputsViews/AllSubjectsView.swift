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
    @State var showConfirmation = false

    var body: some View {
        NavigationView {
            List {
                //                ForEach($model.subjects) { subject in
                //                    Section(subject.label.wrappedValue) {
                //                        ZStack {
                //                            Color.white
                //                            SubjectView(
                //                                images: subject.images, isClickable: false,
                //                                isDeleting: false
                //                            )
                //                            .padding([.top], 7)
                //                        }
                //                    }
                //                    .onTapGesture {
                //                        newSubject = subject.wrappedValue
                //                        addNewSubject.toggle()
                //                    }
                //                }
                ForEach($model.subjects) { subject in
                    HStack(spacing: 10) {
                        SubjectView(
                            images: subject.images, isClickable: false,
                            isDeleting: false
                        )
                        .mask {
                            RoundedRectangle(
                                cornerRadius: 8, style: .continuous)
                        }
                        VStack(alignment: .leading) {
                            Text(subject.label.wrappedValue)
                                .font(
                                    .system(
                                        size: 16, weight: .medium,
                                        design: .default))
                        }
                        .font(.subheadline)
                        .onTapGesture {
                            newSubject = subject.wrappedValue
                            addNewSubject.toggle()
                        }
                        Spacer()
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
                        SubjectView(
                            images: $model.backgrounds, isClickable: false,
                            isDeleting: false
                        )
                        .padding([.top], 7)
                    }
                }
                .onTapGesture {
                    addNewBackground.toggle()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Remove all") {
                        showConfirmation = true
                    }
                    .confirmationDialog(
                        "Are you sure?", isPresented: $showConfirmation
                    ) {
                        Button("Remove all") {
                            model.clearAll()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This action cannot be undone.")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        newSubject = model.newSubject
                        addNewSubject.toggle()
                    }
                }
            }
            .sheet(
                isPresented: $addNewSubject,
                onDismiss: didDismiss
            ) {
                NavigationView {
                    EditSubjectView(subject: $newSubject)
                }
            }
            .sheet(
                isPresented: $addNewBackground
            ) {
                NavigationView {
                    EditBackgroundView(backgrounds: $model.backgrounds)
                }
            }
            .navigationTitle("subjects")
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
