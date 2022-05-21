//
//  PreferredLetterButton.swift
//  BestGen
//
//  Created by Igor Chernobai on 5/15/22.
//

import UIKit

class PreferredLetterButton: UIView {

    var value = 0 {
        didSet {
            labelCounter.text = "\(value)"
            if oldValue < value && oldValue != value {
                blinkBackgroundColor(with: Constants.Colors.mainGreen)
            } else if oldValue != value && value == 0 {
                blinkBackgroundColor(with: Constants.Colors.mainRed)
            }
        }
    }

    private let labelCounter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.mainWhite
        label.font = Constants.Fonts.subTitle?.withSize(25)

        return label
    }()

    private let circledLetter: CircledGenLetterView = {
        let circledLetter = CircledGenLetterView()
        circledLetter.translatesAutoresizingMaskIntoConstraints = false

        return circledLetter
    }()

    init(letter: LetterKey) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        setupView()
        circledLetter.setupView(letter: letter, height: 50)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {


        backgroundColor = Constants.Colors.background
        isUserInteractionEnabled = true
        layer.borderColor = Constants.Colors.mainGreen.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 10

        addSubview(labelCounter)
        addSubview(circledLetter)

        addConstraints(
            [
                labelCounter.centerXAnchor.constraint(equalTo: centerXAnchor),
                labelCounter.topAnchor.constraint(equalTo: topAnchor, constant: 10),

                circledLetter.centerXAnchor.constraint(equalTo: centerXAnchor),
                circledLetter.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
            ]
        )
    }

}
