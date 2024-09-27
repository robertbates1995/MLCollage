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
        Text("This is an inputs page")
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
