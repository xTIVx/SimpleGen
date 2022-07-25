//
//  UIView+Utils.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/15/22.
//

import UIKit

extension UIView {
    func blinkTintColor() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.tintColor = self.tintColor == Constants.Colors.mainGrey ? Constants.Colors.mainGreen : Constants.Colors.mainGrey
        }, completion: { finished in
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.blinkTintAgain), userInfo: nil, repeats: false)
        })
    }

    func blinkBorderColor() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.layer.borderColor = self.layer.borderColor == Constants.Colors.mainGrey.cgColor ? Constants.Colors.mainGreen.cgColor : Constants.Colors.mainGrey.cgColor
        }, completion: { finished in
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.blinkBorderAgain), userInfo: nil, repeats: false)
        })
    }

    func blinkBackgroundColor(with color: UIColor) {
        backgroundColor = color
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {
            self.backgroundColor = Constants.Colors.background
        })
    }

    @objc private func blinkBorderAgain() {
        blinkBorderColor()
    }
    @objc private func blinkTintAgain() {
        blinkTintColor()
    }
}

extension UIViewController {
    class func setUIInterfaceOrientation(_ value: UIInterfaceOrientation) {
        UIDevice.current.setValue(value.rawValue, forKey: "orientation")
    }
}
