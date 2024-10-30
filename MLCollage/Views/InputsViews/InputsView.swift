//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct InputsView: View {
    @State var subjects: [Subject]
    @State var backgrounds: [Subject]
    @State var newInput: Bool = false
    
    var body: some View {
        List {
            InputView(header: "Subjects", count: subjects.count, subjects: subjects.append(Subject()))
            InputView(header: "Backgrounds", count: backgrounds.count, subjects: backgrounds)
        }
    }
}

#Preview {
    InputsView(subjects: Project.mock.subjects, backgrounds: Project.mock.backgrounds)
}


