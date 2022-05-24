//
//  ResultViewModel.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/16/22.
//

import Foundation

class ResultViewModel {

    private let crop: Crop

    init(crop: Crop) {
        self.crop = crop
    }

    func getCrop() -> Crop {
        return self.crop
    }
}
