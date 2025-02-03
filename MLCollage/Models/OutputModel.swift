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
    
    init(collages: [Collage] = [], state: State = State.needsUpdate, blueprints: [CollageBlueprint] = []) {
        self.collages = collages
        self.state = state
        self.blueprints = blueprints
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
    static func makeSubject(width: Double, height: Double) -> UIImage {
        let bounds = CGRect(
            origin: .zero, size: CGSize(width: width, height: height))
        var image = CIImage(color: .clear).cropped(to: bounds)
        
        let spotBounds = CGRect(
            origin: .zero, size: CGSize(width: width / 1.5, height: height / 1.5))
        let blue = CIImage(color: .blue).cropped(to: spotBounds)
        image = blue.composited(over: image)
        
        let red = CIImage(color: .red).cropped(
            to:  CGRect(
                origin: .zero, size: CGSize(width: width / 4, height: height / 4)))
        image = red.composited(over: image)

        return image.cropped(to: bounds).toUIImage()
    }
    
    static let flip = CollageBlueprint(mod: Modification(translateX: 0.5, translateY: 0.5, scale: 0.5, flipY: true),
                                          subjectImage: makeSubject(width: 200, height: 200),
                                 background: .crazyBackground1,
                                 label: "apple",
                                 fileName: "apple_.png")
    static let rotate = CollageBlueprint(mod: Modification(translateX: 0.5, translateY: 0.5, scale: 0.5, rotate: 0.5),
                                          subjectImage: makeSubject(width: 200, height: 200),
                                 background: .crazyBackground1,
                                 label: "apple",
                                 fileName: "apple_.png")

    static let mock = OutputModel(collages: [], blueprints: [flip, rotate])
}
