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
        static let subTitle = UIFont(name: "Arial-BoldMT", size: ScreenSizeConfig.isSmallDevice ? 14 : 18)
        static let letterTitle = UIFont(name: "Arial-BoldMT", size: ScreenSizeConfig.isSmallDevice ? 19 : 24)
    }

    enum AdIdentifiers {
        static let rewardedAd = "ca-app-pub-3940256099942544/1712485313"
        static let bottomAd = "ca-app-pub-3940256099942544/2934735716"
    }

    enum ScreenSizeConfig {
        static let isSmallDevice = UIScreen.main.bounds.height < 812
        static let isIPad = UIDevice.current.userInterfaceIdiom == .pad
    }
}

enum Product: String, CaseIterable {
    case Free = "free"
    case Ads = "com.tiv.c.ads"
    case Crops = "com.tiv.c.crops"
    case Full = "com.tiv.c.full"
}
