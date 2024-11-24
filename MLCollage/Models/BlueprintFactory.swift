//
//  File.swift
//  MLCollage
//
//  Created by Robert Bates on 11/20/24.
//

import Foundation

struct BlueprintFactory {
    func createBlueprints(_ inputModel: InputModel, _ settingsModel: SettingsModel) -> [CollageBlueprint] {
        var set = [CollageBlueprint]()
        for subject in inputModel.subjects {
            var count = 1
            for mod in createModList(settingsModel: settingsModel) {
                guard let background = inputModel.backgrounds.randomElement(),
                      let image = subject.images.randomElement()
                else {
                    continue
                }
                let blueprint = CollageBlueprint(
                    mod: mod, subjectImage: image, background: background,
                    label: subject.label,
                    fileName: "\(subject.label)_\(count).png")
                set.append(blueprint)
                count += 1
            }
        }
        return set
    }
    
    private func createModList(settingsModel: SettingsModel) -> [Modification] {
        (1...Int(settingsModel.numberOfEachSubject)).map { _ in
            var newMod = Modification()
            if settingsModel.scale {
                newMod.scale = CGFloat.random(
                    in: settingsModel.scaleLowerBound..<settingsModel.scaleUpperBound)
            }
            if settingsModel.rotate {
                
                newMod.rotate = CGFloat.random(
                    in: (settingsModel.rotateLowerBound * 2 * .pi)..<(settingsModel
                        .rotateUpperBound * 2 * .pi))
            }
            if settingsModel.flipHorizontal {
                newMod.flipX = Bool.random()
                newMod.flipY = Bool.random()
            }
            //translate should be applied last
            if settingsModel.translate {
                newMod.translateX = CGFloat.random(
                    in: 0.0..<1.0)
                newMod.translateY = CGFloat.random(
                    in: 0.0..<1.0)
            }
            return newMod
        }
    }
}
