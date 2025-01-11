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
    var outputSize: CGFloat = 100
    
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
        Task {
            state = .loading
            await foo(blueprints: blueprints, size: outputSize)
            state = .ready
        }
    }
    
    nonisolated func foo(blueprints: [CollageBlueprint], size: CGFloat) async {
        for blueprint in blueprints {
            let collage = blueprint.create(size: size)
            await MainActor.run {
                collages.append(collage)
            }
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
