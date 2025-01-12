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
            task?.cancel()
            state = .needsUpdate
            collages.removeAll()
        }
    }
    var task: Task<Void,Never>?
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
        task = Task {
            state = .loading
            await withDiscardingTaskGroup { group in
                for blueprint in blueprints {
                    group.addTask { [outputSize] in
                        guard !Task.isCancelled else { return }
                        let collage = blueprint.create(size: outputSize)
                        await MainActor.run {
                            guard !Task.isCancelled else { return }
                            self.collages.append(collage)
                        }
                    }
                }
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
