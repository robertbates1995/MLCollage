//
//  InputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct InputsView: View {
    var subjects: [CIImage]
    var backgrounds: [CIImage]
    var body: some View {
        List {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
    
    init(subjects: [CIImage], backgrounds: [CIImage]) {
        self.subjects = subjects
        self.backgrounds = backgrounds
    }
}

#Preview {
    InputsView(subjects: [CIImage(image: .apple1)!,
                          CIImage(image: .apple2)!,
                          CIImage(image: .apple3)!,],
               backgrounds: [CIImage(image: .crazyBackground1)!,
                             CIImage(image: .crazyBackground2)!,
                             CIImage(image: .crazyBackground3)!])
}
