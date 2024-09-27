//
//  OutputsView.swift
//  MLCollage
//
//  Created by Robert Bates on 9/25/24.
//

import SwiftUI

struct OutputsView: View {
    @State var outputs: [CIImage]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    //replace this with actual output photos
    OutputsView(outputs: [CIImage(image: .crazyBackground1)!,
                          CIImage(image: .crazyBackground2)!,
                          CIImage(image: .crazyBackground3)!])
}
