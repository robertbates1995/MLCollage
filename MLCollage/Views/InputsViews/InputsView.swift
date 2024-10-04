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
    
    var body: some View {
        List {
            InputsViewSection(header: "Subjects", count: subjects.count, subjects: subjects)
            InputsViewSection(header: "Backgrounds", count: backgrounds.count, subjects: backgrounds)
        }
    }
}

#Preview {
    InputsView(subjects: Project.mock.subjects, backgrounds: Project.mock.backgrounds)
}


