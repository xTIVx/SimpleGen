//
//  Buttons.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import UIKit

extension UIButton {

    func updateButtonToEmpty() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.tintColor = Constants.Colors.mainGrey
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.backgroundColor = .clear
        let rect = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: 40, height: 40))
        let layer = CAShapeLayer.init()
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 20)
        layer.path = path.cgPath
        layer.strokeColor = UIColor.lightGray.cgColor
        layer.lineDashPattern = [10,5]
        layer.backgroundColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.name = "EmptyButton"
        self.layer.addSublayer(layer)
        self.blinkTintColor()
    }

    func updateButtonToLetter(letter: LetterKey) {
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                 if layer.name == "EmptyButton" {
                      layer.removeFromSuperlayer()
                 }
             }
            self.setImage(nil, for: .normal)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isUserInteractionEnabled = true
        self.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.layer.cornerRadius = 20

        self.titleLabel?.font = Constants.Fonts.letterTitle
        self.titleLabel?.textColor = Constants.Colors.mainWhite
        self.setTitle(letter.rawValue, for: .normal)

        switch letter {
        case .W:
            self.backgroundColor = Constants.Colors.mainRed
        case .X:
            self.backgroundColor = Constants.Colors.mainRed
        default:
            self.backgroundColor = Constants.Colors.mainGreen
        }
    }
}
