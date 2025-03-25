//
//  AddButton.swift
//  MLCollage
//
//  Created by Robert Bates on 3/25/25.
//

import SwiftUI

struct AddButton: View {
    @Binding var model: InputModel
    @Binding var newSubject: Subject
    @Binding var addNewSubject: Bool

//    func addButton() -> ToolbarItem {
//        ToolbarItem(placement: .topBarTrailing) {
//            Button(action: {
//                newSubject = model.newSubject
//                addNewSubject.toggle()
//            },
//                   label: {
//                Image(systemName: "plus")
//            })
//        }
//    }
    
    var body: some View {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                newSubject = model.newSubject
                addNewSubject.toggle()
            },
                   label: {
                Image(systemName: "plus")
            })
        }
    }

}
