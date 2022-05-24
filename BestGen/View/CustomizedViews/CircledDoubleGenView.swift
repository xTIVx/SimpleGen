//
//  CircledDoubleGenView.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/22/22.
//

import UIKit

class CircledDoubleGenView: UIView {

    private let topLetterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.letterTitle?.withSize(18)
        label.textColor = Constants.Colors.mainWhite

        return label
    }()

    private let bottomLetterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Fonts.letterTitle?.withSize(18)
        label.textColor = Constants.Colors.mainWhite

        return label
    }()

    func setupView(topLetter: LetterKey, bottomLetter: LetterKey, height: CGFloat) {

        addSubview(topLetterLabel)
        addSubview(bottomLetterLabel)

        layer.cornerRadius = height / 2
        topLetterLabel.text = topLetter.rawValue
        bottomLetterLabel.text = bottomLetter.rawValue

        switch topLetter {
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

                topLetterLabel.topAnchor.constraint(equalTo: topAnchor, constant: 1),
                topLetterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

                bottomLetterLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
                bottomLetterLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            ]
        )
    }
}
