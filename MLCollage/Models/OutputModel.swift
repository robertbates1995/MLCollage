//
//  OutputModel.swift
//  MLCollage
//
//  Created by Robert Bates on 10/30/24.
//

import SwiftUI

@Observable
@MainActor
class OutputModel {
    var collages: [Collage]
    var canExport: Bool { state == .ready}
    var state = State.needsUpdate
    var factories: [CollageBlueprint] = []
    
    enum State {
        case needsUpdate
        case loading
        case ready
    }
    
    init(collages: [Collage], state: State = State.needsUpdate, factories: [CollageBlueprint]) {
        self.collages = collages
        self.state = state
        self.factories = factories
    }
    
    func updateIfNeeded() {
        guard state == .needsUpdate else {
            return
        }
        state = .loading
        collages = factories.map({$0.create()})
        state = .ready
    }
}

extension OutputModel {
    static let factory = CollageBlueprint(mod: Modification(),
                                 subject: .apple1,
                                 background: .crazyBackground1,
                                 label: "apple",
                                 fileName: "apple_.png")
    static let mock = OutputModel(collages: [], factories: [factory])
}
