//
//  MainViewModel.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation

class MainViewModel {

    private var crops = [Crop]()
    private var preferredCombo: [LetterKey: Int] = [.G: 3, .Y: 3, .H: 0]

    func isAllLettersAreSet() -> Bool {
        return crops.map { crop in
            crop.letters.filter { $0.key == .empty }
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

    func getAllCrops() -> [Crop] {
        return crops
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
        return crops.count
    }

    func getCrop(at row: Int) -> Crop {
        return crops[row]
    }

    func updateCrop(crop: Int, letter: Int, newKey: LetterKey, completion: (()->())) {
        crops[crop].letters[letter].key = newKey
        completion()
    }

    // скрещиваем растения
    private func setupLetterChunk(samples: [Crop]) -> Crop {
        var result = Crop(letters: [Letter]())
        result.parents = samples
        // Пробегаем по 6 генам которые гарантированно есть у растения
        for index in 0...5 {
            var tempLetter = Letter(key: .X)
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
                    result.letters[index].comparedGens?.append($0.element.key)
                }
            }
            result.letters.append(tempLetter)
        }

        return result
    }


    // n - количество элементов в одной комбинации (комбинировать по 3 или по 4 например)
    func generateAllCombos( finalResult: inout [[Crop]], samples: [Crop], n: Int = 3) -> [[Crop]] {
        guard n <= samples.count && n <= 6 else { return finalResult }

        let allCombinations = crops.combinationsWithoutRepetition.filter {$0.count == n}
        let chunk = setupLetter(samples: allCombinations)
        finalResult.append(chunk)
        //        chunk.forEach { elem in
        //            let qwe = elem.map { $0 }
        //            print(qwe.map {$0.key})
        //            print(qwe.map {$0.parents})
        //            print("-----------------------")
        //        }
        return generateAllCombos(finalResult: &finalResult, samples: samples, n: n + 1)
    }

    func countLetters(crop: Crop) -> [LetterKey: Int] {
        var result = [LetterKey: Int]()
        crop.letters.forEach {
            guard preferredCombo.keys.contains($0.key) else { return }
            result[$0.key] == nil ?
            (result[$0.key] = 1) :
            (result[$0.key]! += 1)
        }
        return result
    }

    func setupLetter(samples: [[Crop]]) -> [Crop] {
        return samples.map { setupLetterChunk(samples: $0) }
    }


    func compareMatches(matches: [Int: [LetterKey: Int]]) -> [Int: Int] {
        var result = [Int: Int]()
        matches.forEach { match in
            result[match.key] = match.value.values.reduce(0) { $0 + $1 }
        }
        return result
    }

    func searchForBestMatch(crops: [Crop]) -> Crop? {
        var countedCrop = [Int: [LetterKey: Int]]()
        crops.enumerated().forEach { index, crop in
            countedCrop[index] = countLetters(crop: crop)
        }
        if let result = compareMatches(matches: countedCrop).max(by: { $0.value < $1.value }) {
            return crops[result.key]
        }
        return nil
    }

    func searchAllBestCrops() -> [Crop] {
        var allAcceptedCrops = [Crop]()
        if let crop = searchForBestMatch(crops: crops) {
            allAcceptedCrops.append(crop)
        }
        var generatedCombos = [[Crop]]()
        generatedCombos = generateAllCombos(finalResult: &generatedCombos, samples: crops)
        let crossbreededCrops = setupLetter(samples: generatedCombos)

        if let additionalAcceptedCrop = searchForBestMatch(crops: crossbreededCrops) {
            allAcceptedCrops.append(additionalAcceptedCrop)
        }

        return allAcceptedCrops
    }

    func compareBestCrops() -> [Crop] {
        let crops = searchAllBestCrops()
        let countedBestCrops = crops.enumerated().map { [$0.offset : countLetters(crop: $0.element)] }.first
        // [0: [BestGen.LetterKey.Y: 2, BestGen.LetterKey.G: 1]]
        var best = crops

        if let perfectMatch = countedBestCrops?.filter({ $0.value == preferredCombo }).keys.first {
            best = [crops[perfectMatch]]
        }

        return best
    }
}
