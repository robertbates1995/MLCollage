//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct AllSubjectsView: View {
    @Binding var model: InputModel
    
    var body: some View {
        List {
            ForEach(model.subjects.sorted(by: {$0.key < $1.key}), id: \.key) { (key, subject) in
                SubjectView(label: key, images: subject.images) { image in model.add(image: image, label: key)}
            }
            SubjectView(label: "backgrounds", images: model.backgrounds) { image in model.add(background: image)}
        }
        .padding()
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    AllSubjectsView(model: $model)
}


