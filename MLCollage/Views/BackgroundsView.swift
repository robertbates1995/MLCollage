//
//  BackgroundsView.swift
//  MLCollage
//
//  Created by Robert Bates on 3/24/25.
//

import Foundation
import SwiftUI


struct BackgroundsView: View {
    @Binding var model: InputModel

    
    var body: some View {
        NavigationView {
            
        }
    }
}

#Preview {
    @Previewable @State var model = InputModel.mock
    BackgroundsView(model: $model)
}
