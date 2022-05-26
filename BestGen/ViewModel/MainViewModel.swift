//
//  MainViewModel.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation

class MainViewModel {

    // MARK: Properties
    private var crops = [
        Crop(letters: [
            .init(key: .G, comparedGens: nil),
            .init(key: .W, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .W, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .W, comparedGens: nil)
        ]),
        Crop(letters: [
            .init(key: .H, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .H, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .W, comparedGens: nil),
            .init(key: .H, comparedGens: nil)
        ]),
        Crop(letters: [
            .init(key: .G, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .Y, comparedGens: nil),
            .init(key: .W, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .X, comparedGens: nil)
        ]),
        Crop(letters: [
            .init(key: .H, comparedGens: nil),
            .init(key: .Y, comparedGens: nil),
            .init(key: .G, comparedGens: nil),
            .init(key: .H, comparedGens: nil),
            .init(key: .H, comparedGens: nil),
            .init(key: .H, comparedGens: nil)
        ]),
    ]
    private var preferredCombo: [LetterKey: Int] = [.G: 4, .Y: 2, .H: 0]

    private var topCrop: Crop?

    func isAllLettersAreSet() -> Bool {
        return crops.map { crop in
            crop.letters.filter { $0.key == .empty }
        }
            .first!
            .isEmpty
    }

    // MARK: CRUD funcs

    func getTopCrop() -> Crop? {
        if let top = self.topCrop {
            return top
        } else {
            self.topCrop = findBest()
            return self.topCrop
        }
    }

    func updatePreferredCombo(combo: [LetterKey: Int]) {
        preferredCombo = combo
    }

    func getPreferredCombo() -> [LetterKey: Int] {
        preferredCombo
    }

    func sendPreferredCombo() -> [LetterKey: Int] {
        preferredCombo.filter { $0.value != 0 }
    }

    func getAllCrops() -> [Crop] {
        crops
    }

    func addCropRow() {
        crops.insert(Crop(letters:[Letter(),Letter(),Letter(),Letter(),Letter(),Letter()]), at: 0)
    }

    func removeCrop(at row: Int) {
        crops.remove(at: row)
    }

    func removeAllCrops() {
        crops.removeAll()
    }

    func getSamplesCount() -> Int {
        crops.count
    }

    func getCrop(at row: Int) -> Crop {
        crops[row]
    }

    func updateCrop(crop: Int, letter: Int, newKey: LetterKey, completion: (()->())) {
        crops[crop].letters[letter].key = newKey
        completion()
    }

    // MARK: Crossbreed funcs

    // n - количество элементов в одной комбинации (комбинировать по 3 или по 4 например)
    func generateAllCombos( finalResult: inout [[Crop]], samples: [Crop], n: Int = 3) -> [[Crop]] {
        guard n <= samples.count && n <= 6 else { return finalResult }

        let allCombinations = samples.combinationsWithoutRepetition.filter {$0.count == n}
        allCombinations.forEach { finalResult.append($0) }

        return generateAllCombos(finalResult: &finalResult, samples: samples, n: n + 1)
    }

    private func setupLetterChunk(samples: [Crop]) -> Crop {
        var result = Crop(letters: [Letter]())
        result.parents = samples
        // Пробегаем по 6 генам которые гарантированно есть у растения
        for index in 0...5 {
            var tempLetter = Letter(key: .empty)
            var letterKeyPriority = [LetterKey : Float]()

            samples.forEach { crop in
                letterKeyPriority[crop.letters[index].key] == nil ?
                (letterKeyPriority[crop.letters[index].key] = crop.letters[index].weight) :
                (letterKeyPriority[crop.letters[index].key]! += crop.letters[index].weight)
            }

            let sortedLetterKeys = letterKeyPriority.sorted(by: { $0.value > $1.value } )

            tempLetter.key = sortedLetterKeys.first!.key

            let maxValue = sortedLetterKeys.first!.value

            sortedLetterKeys.enumerated().forEach {
                if $0.offset >= 1 && $0.element.value == maxValue {
                    tempLetter.comparedGens == nil ?
                    (tempLetter.comparedGens = [$0.element.key]) :
                    (tempLetter.comparedGens!.append($0.element.key))
                }
            }

            result.letters.append(tempLetter)
        }
        return result
    }

    func setupLetter(samples: [[Crop]]) -> [Crop] {
        return samples.map { setupLetterChunk(samples: $0) }
    }

    func findBest() -> Crop? {
        var generatedCombos = [[Crop]]()
        generatedCombos = generateAllCombos(finalResult: &generatedCombos, samples: crops)
        let crops = setupLetter(samples: generatedCombos)
        var targetCrop = preferredCombo
        var strength = [Int: Int]()

        crops.enumerated().forEach { index, crop in
            crop.letters.forEach { letter in
                if targetCrop.keys.contains(letter.key) && targetCrop[letter.key]! != 0 {
                    targetCrop[letter.key]! -= 1
                    strength[index] == nil ? (strength[index] = 1) : (strength[index]! += 1)
                }
            }
            targetCrop = preferredCombo
        }
        var sortedIndex = strength.sorted(by: {$0.value > $1.value})

        if let topValue = sortedIndex.first?.value {
            sortedIndex = sortedIndex.filter { $0.value == topValue }
        } else {
            return nil
        }

        return sortedIndex.map { crops[$0.key] }.max { $0.betterScore < $1.betterScore }
    }
}
