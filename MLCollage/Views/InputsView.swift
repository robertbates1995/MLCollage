//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct InputsView: View {
    @State var subjects: [CIImage]
    @State var backgrounds: [CIImage]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum:100))]) {
                ForEach(0..<subjects.count) { index in
                    Image(uiImage: UIImage(cgImage: subjects[index].cgImage!))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
        }
    }
}

#Preview {
    InputsView(subjects: ,
               backgrounds: [CIImage(image: .crazyBackground1)!,
                             CIImage(image: .crazyBackground2)!,
                             CIImage(image: .crazyBackground3)!])
}
