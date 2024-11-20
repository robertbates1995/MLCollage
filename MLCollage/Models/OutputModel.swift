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
    var blueprints: [CollageBlueprint] = [] {
        didSet {
            state = .needsUpdate
            collages.removeAll()
        }
    }
    var progress: CGFloat? {
        guard blueprints.count > 0 else {
            return nil
        }
        return CGFloat(collages.count) / CGFloat(blueprints.count)
    }
    
    enum State {
        case needsUpdate
        case loading
        case ready
    }
    
    init(collages: [Collage] = [], state: State = State.needsUpdate, factories: [CollageBlueprint] = []) {
        self.collages = collages
        self.state = state
        self.blueprints = factories
    }
    
    func updateIfNeeded() {
        guard state == .needsUpdate else {
            return
        }
        state = .loading
        Task {
            for blueprint in blueprints {
                collages.append(blueprint.create())
                await Task.yield()
            }
            state = .ready
        }
    }
}

extension OutputModel {
    static let factory = CollageBlueprint(mod: Modification(),
                                 subjectImage: .apple1,
                                 background: .crazyBackground1,
                                 label: "apple",
                                 fileName: "apple_.png")
    static let mock = OutputModel(collages: [], factories: [factory])
}
