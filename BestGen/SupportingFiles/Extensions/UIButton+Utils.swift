//
//  Buttons.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/11/22.
//

import UIKit

extension UIButton {

    func updateButtonToEmpty() {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        setImage(UIImage(systemName: "plus"), for: .normal)
        tintColor = Constants.Colors.mainGrey
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        backgroundColor = .clear
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
        blinkTintColor()
    }

    func updateButtonToLetter(letter: LetterKey) {
        if let sublayers = layer.sublayers {
            for layer in sublayers {
                 if layer.name == "EmptyButton" {
                      layer.removeFromSuperlayer()
                 }
             }
            setImage(nil, for: .normal)
        }
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        widthAnchor.constraint(equalToConstant: 40).isActive = true
        layer.cornerRadius = 20

        titleLabel?.font = Constants.Fonts.letterTitle
        titleLabel?.textColor = Constants.Colors.mainWhite
        setTitle(letter.rawValue, for: .normal)

        switch letter {
        case .W:
            backgroundColor = Constants.Colors.mainRed
        case .X:
            backgroundColor = Constants.Colors.mainRed
        default:
            backgroundColor = Constants.Colors.mainGreen
        }
    }
}
