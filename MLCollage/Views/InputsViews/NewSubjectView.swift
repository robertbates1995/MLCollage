//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import SwiftUI

struct NewSubjectView: View {
    @Binding var subject: InputSubject
    
    var body: some View {
        Text("Enter New Subject")
            .font(.largeTitle)
        Divider()
        HStack {
            Text("Label: ")
            TextField("new subject", text: $subject.label)
                .padding()
                .background(Color.black.opacity(0.1))
        }
        .padding()
        List {
            //SubjectView(subject: subject)
        }
        Spacer()
    }
}

#Preview {
    @Previewable @State var model = InputSubject(label: "")
    NewSubjectView(subject: $model)
}
