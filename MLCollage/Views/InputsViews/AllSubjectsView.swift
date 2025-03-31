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
                ForEach($model.subjects) { subject in
                    Section {
                        HStack(spacing: 10) {
                            SubjectRowView(
                                images: subject.images,
                                size: 100
                            )
                        }
                    } header: {
                        Text(subject.label.wrappedValue.uppercased())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipped()
                            .font(
                                .system(.headline, weight: .medium).width(
                                    .expanded)
                            )
                            .tint(.accentColor)
                    }
                    .contentShape(.rect())
                    .onTapGesture {
                        newSubject = subject.wrappedValue
                        addNewSubject.toggle()
                    }
                }
                .onDelete { indexSet in
                    model.subjects.remove(atOffsets: indexSet)
                }
            }
            .overlay {
                if model.subjects.isEmpty {
                    ContentUnavailableView(
                        "No Subjects",
                        systemImage: "photo",
                        description: Text("Please add a subject to continue")
                    )
                    .onTapGesture {
                        newSubject = model.newSubject
                        addNewSubject.toggle()
                    }
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
                    Button(
                        action: {
                            newSubject = model.newSubject
                            addNewSubject.toggle()
                        },
                        label: {
                            Image(systemName: "plus")
                        })
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
            .navigationTitle("Subjects")
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

#Preview {
    @Previewable @State var model = InputModel(subjects: [], backgrounds: [])
    AllSubjectsView(model: $model)
}
