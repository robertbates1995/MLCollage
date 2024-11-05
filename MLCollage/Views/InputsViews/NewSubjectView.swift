//
//  NewSubjectView.swift
//  MLCollage
//
//  Created by Robert Bates on 11/4/24.
//

import SwiftUI

struct NewSubjectView: View {
    @State var title: String = "New Subject"
    
    var body: some View {
        Text("New Subject")
            .font(.largeTitle)
        TextField("new subject", text: $title)
            .onSubmit {
                
            }
    }
}

#Preview {
    NewSubjectView()
}
