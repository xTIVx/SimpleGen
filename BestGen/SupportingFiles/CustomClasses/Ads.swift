//
//  Ads.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/25/22.
//

import Foundation
import GoogleMobileAds

protocol ADS: GADFullScreenContentDelegate {}

class Ads: NSObject, ADS {

    private var delegate: UIViewController

    init(delegate: UIViewController) {
        self.delegate = delegate
        super.init()
    }

    func createSmallBanner(adUnitID: String) -> GADBannerView {
        let smallBanner = GADBannerView()
        smallBanner.translatesAutoresizingMaskIntoConstraints = false
        smallBanner.adUnitID = adUnitID
        smallBanner.backgroundColor = .clear
        smallBanner.load(GADRequest())
        smallBanner.rootViewController = delegate

        return smallBanner
    }

    func createRewardedAd() -> GADRewardedAd {
        GADRewardedAd()
    }
    
    func loadRewardedAd(withAdUnitID: String, completion: @escaping ((GADRewardedAd?) -> ()))  {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: withAdUnitID,
                           request: request,
                           completionHandler: { ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(ad)
            print("Rewarded ad loaded.")
        }
        )
    }

    func showRewardedAd(rewardedAd: GADRewardedAd) {
        rewardedAd.present(fromRootViewController: delegate, userDidEarnRewardHandler: {})
    }

    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
}
