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
    var images: [CIImage]
    
    var body: some View {
        Section(header: Text(header)){
            LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                ForEach(0..<count) { index in
                    Image(uiImage: UIImage(ciImage: images[index]))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}

#Preview {
    InputsViewSection(header: "Test Header", count: Project.mock.subjects.count, images: Project.mock.subjects.map({ $0.image }))
}
