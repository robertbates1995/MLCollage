//
//  InputsViewSection.swift
//  MLCollage
//
//  Created by Robert Bates on 10/3/24.
//

import SwiftUI

struct InputsViewSection: View {
    var header: String
    var count: Int
    var subjects: [Subject]
    
    var body: some View {
        Section(header: Text(header)) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                ForEach(subjects, id: \.label) { subject in
                    VStack {
                        Image(uiImage: subject.image.toUIImage())
                            .resizable()
                            .padding()
                            .aspectRatio(contentMode: .fill)
                            .background(Color(.gray.withAlphaComponent(0.2)))
                            .clipShape(.rect(cornerRadius: 10))
                            .padding(3)
                        Text(subject.label)
                    }
                }
            }
        }
    }
}

#Preview {
    InputsViewSection(header: "Test Header", count: Project.mock.subjects.count, subjects: Project.mock.subjects)
}
