//
//  MainViewModel.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation

class MainViewModel {

    private var crops = [[Letter]]()
    private var preferredCombo: [LetterKey: Int] = [.G: 3, .Y: 3, .H: 0]

    func isAllLettersAreSet() -> Bool {
        return crops.map { letters in
            letters.filter { $0.key == .empty }
        }
            .first!
            .isEmpty
    }

    func updatePreferredCombo(combo: [LetterKey: Int]) {
        preferredCombo = combo
    }

    func getPreferredCombo() -> [LetterKey: Int] {
        return preferredCombo
    }

    func sendPreferredCombo() -> [LetterKey: Int] {
        return preferredCombo.filter { $0.value != 0 }
    }

    func getAllCrops() -> [[Letter]] {
        return crops
    }

    func addCropRow() {
        crops.insert([Letter(),Letter(),Letter(),Letter(),Letter(),Letter()], at: 0)
    }

    func removeCrop(at row: Int) {
        crops.remove(at: row)
    }

    func removeAllCrops() {
        crops.removeAll()
    }

    func getSamplesCount() -> Int {
        return crops.count
    }

    func getCrop(at row: Int) -> [Letter] {
        return crops[row]
    }

    func updateCrop(crop: Int, letter: Int, newKey: LetterKey, completion: (()->())) {
        crops[crop][letter].key = newKey
        completion()
    }

    
}
