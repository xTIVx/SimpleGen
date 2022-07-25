//
//  Crop.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation

struct Crop {
    var letters: [Letter]
    var parents: [Crop]?
    var betterScore: Int {
        var score = 0
        letters.forEach { letter in
            switch letter.key {
            case .Y:
                score += 1
            case .G:
                score += 1
            case .H:
                score += 1
            case .W:
                score -= 1
            case .X:
                score -= 1
            default:
                score += 0
            }
        }
        return score
    }
}

struct Letter: Equatable {
    var key: LetterKey = .empty
    var comparedGens: [LetterKey]?
    var weight: Float {
        switch key {
        case .Y:
            return 0.6
        case .G:
            return 0.6
        case .H:
            return 0.6
        case .W:
            return 1.0
        case .X:
            return 1.0
        default:
            return 0
        }
    }
}

enum LetterKey: String {
    case Y = "Y"
    case G = "G"
    case H = "H"
    case W = "W"
    case X = "X"
    case empty
}
