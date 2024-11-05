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
        Text("New Subject")
            .font(.largeTitle)
        TextField("new subject", text: $subject.label)
            .onSubmit {
                
            }
    }
}

#Preview {
    @Previewable @State var model = InputSubject(label: "preview label")
    NewSubjectView(subject: $model)
}
