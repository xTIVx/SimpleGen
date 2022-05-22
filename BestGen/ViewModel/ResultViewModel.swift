//
//  ResultViewModel.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/16/22.
//

import Foundation

class ResultViewModel {

    var allCrops: [Crop]!
    var preferredCombo: [LetterKey: Int]!

    init(allCrops: [Crop], preferredCombo: [LetterKey: Int]) {
        self.allCrops = allCrops
        self.preferredCombo = preferredCombo
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

        let allCombinations = allCrops.combinationsWithoutRepetition.filter {$0.count == n}
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
        if let crop = searchForBestMatch(crops: allCrops) {
            allAcceptedCrops.append(crop)
        }
        var generatedCombos = [[Crop]]()
        generatedCombos = generateAllCombos(finalResult: &generatedCombos, samples: allCrops)
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


//preferred [.G: 3, .H: 0, .Y: 3]
//          [index: кол-во совпадений]
//best      [0: [.G: 1, .Y: 3]]
//for
// [.G: 2, .Y: 2]

    // 0) Пробежаться по массиву входящих растокв на предмет совпадения
    // 1) Создать аррей скрещенных комбинаций ([[Letter]])!!!!!
    // 2) Пробежать по массиву и перевести каждый расток в числовой формат с помощью countLetters
    // 3) Внутри этой же функции

