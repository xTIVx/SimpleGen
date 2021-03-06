//
//  Constants.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import Foundation
import UIKit

enum Constants {

    enum Colors {
        static let mainRed = UIColor(red: 140 / 255, green: 47 / 255, blue: 32 / 255, alpha: 1)
        static let mainGreen = UIColor(red: 123 / 255, green: 161 / 255, blue: 56 / 255, alpha: 1)
        static let mainWhite = UIColor.white
        static let mainGrey = UIColor(red: 101 / 255, green: 96 / 255, blue: 91 / 255, alpha: 1)
        static let background = UIColor(red: 33 / 255, green: 37 / 255, blue: 41 / 255, alpha: 1)
    }

    enum Fonts {
        static let subTitle = UIFont(name: "Arial-BoldMT", size: 18)
        static let letterTitle = UIFont(name: "Arial-BoldMT", size: 24)
    }

    enum AdIdentifiers {
        static let rewardedAd = "ca-app-pub-3723771389568265/8048988554"
        static let bottomAd = "ca-app-pub-3723771389568265/4301315231"
    }

}

enum Product: String, CaseIterable {
    case free = "free"
    case ads = "com.tiv.c.ads"
    case crops = "com.tiv.c.crops"
    case full = "com.tiv.c.full"
}
