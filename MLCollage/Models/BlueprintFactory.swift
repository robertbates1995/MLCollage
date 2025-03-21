//
//  File.swift
//  MLCollage
//
//  Created by Robert Bates on 11/20/24.
//

import Foundation

struct BlueprintFactory {
    func createBlueprints(_ inputModel: InputModel, _ settingsModel: SettingsModel) -> [CollageFactory] {
        var set = [CollageFactory]()
        var count = 1
        for subject in inputModel.subjects {
            for mod in createModList(settingsModel: settingsModel) {
                guard let background = inputModel.backgrounds.randomElement(),
                      let image = subject.images.randomElement()
                else {
                    continue
                }
                let blueprint = CollageFactory(
                    mod: mod, subjectImage: image.uiImage, background: background.uiImage,
                    label: subject.label,
                    fileName: "\(count).png")
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
                    in: 0.1 ..< 0.8)
            }
            if settingsModel.rotate {
                newMod.rotate = CGFloat.random(
                    in: (0.0) ..< (1.0 * 2 * .pi))
            }
            if settingsModel.mirror {
                newMod.flipX = Bool.random()
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
