//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct AllSubjectsView: View {
    @Binding var model: InputModel
    @State var addingSubject: Bool = false
    @State var newSubject: Subject? = nil
    
    var body: some View {
        List {
            ForEach(model.subjects.sorted(by: {$0.key < $1.key}), id: \.key) { (key, subject) in
                SubjectView(label: key, images: subject.images) { image in model.add(image: image, label: key)}
            }
            SubjectView(label: "backgrounds", images: model.backgrounds) { image in model.add(background: image)}
        }
        .padding()
        HStack {
            Button("Add Subject") {
                addingSubject.toggle()
            }
        }.sheet(isPresented: $addingSubject, onDismiss: didDismiss) {
            NewSubjectView()
        }
    }
    
    func didDismiss() {
        if newSubject != nil {
            model.add(subject: newSubject!)
        }
        newSubject = nil
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    AllSubjectsView(model: $model)
}


