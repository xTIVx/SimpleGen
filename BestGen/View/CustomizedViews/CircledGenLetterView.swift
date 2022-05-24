//
//  CircledGenLetterView.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/14/22.
//

import UIKit

class CircledGenLetterView: UIView {

    private let letterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.letterTitle?.withSize(30)
        label.textColor = Constants.Colors.mainWhite

        return label
    }()

    func setupView(letter: LetterKey, height: CGFloat) {

        addSubview(letterLabel)
        layer.cornerRadius = height / 2
        letterLabel.text = letter.rawValue

        switch letter {
        case .W:
            self.backgroundColor = Constants.Colors.mainRed
        case .X:
            self.backgroundColor = Constants.Colors.mainRed
        default:
            self.backgroundColor = Constants.Colors.mainGreen
        }

        NSLayoutConstraint.activate(
            [
                widthAnchor.constraint(equalToConstant: height),
                heightAnchor.constraint(equalToConstant: height),

                letterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
    }
}
