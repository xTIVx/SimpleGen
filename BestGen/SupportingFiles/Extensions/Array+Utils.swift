//
//  Extentions.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation
import UIKit

extension Array {
    var combinationsWithoutRepetition: [[Element]] {
        guard !isEmpty else { return [[]] }
        return Array(self[1...]).combinationsWithoutRepetition.flatMap { [$0, [self[0]] + $0] }
    }
}
