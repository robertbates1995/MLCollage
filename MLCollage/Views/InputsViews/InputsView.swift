//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct InputsView: View {
    @State var subjects: [UIImage]
    @State var backgrounds: [UIImage]
    
    var body: some View {
        List {
            InputsViewSection(header: "Subjects", count: subjects.count, images: subjects)
            InputsViewSection(header: "Backgrounds", count: backgrounds.count, images: backgrounds)
        }
    }
}

#Preview {
    InputsView(subjects: Project.mock.subjects.map({ $0.image.toUIImage()}),
               backgrounds: Project.mock.backgrounds.map({$0.toUIImage()}))
}


