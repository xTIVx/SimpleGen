//
//  Letter.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation

struct Letter {
    var key: LetterKey = .empty
    var parents: [[Letter]]?
    var comparedGens: [LetterKey]?
    var v: Float {
        switch key {
        case .Y:
            return 1
        case .G:
            return 1
        case .H:
            return 1
        case .W:
            return 1.5
        case .X:
            return 1.5
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
